--
-- PostgreSQL database dump
--

\restrict VNfeEFLJoo9hTdmEd5Ru7ELbgNbqNVUCzjSmzkdDhngzODU85VHUbsJFNbCsDoz

-- Dumped from database version 17.10 (Debian 17.10-1.pgdg13+1)
-- Dumped by pg_dump version 18.4 (Debian 18.4-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: attendance_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.attendance_status_enum AS ENUM (
    'Present',
    'Absent',
    'Excused'
);


--
-- Name: billing_cycle_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.billing_cycle_enum AS ENUM (
    'monthly',
    'yearly'
);


--
-- Name: club_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.club_status_enum AS ENUM (
    'Active',
    'Inactive',
    'Closing'
);


--
-- Name: event_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.event_type_enum AS ENUM (
    'Training',
    'Match',
    'Meeting'
);


--
-- Name: fee_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.fee_status_enum AS ENUM (
    'Due',
    'Partial',
    'Paid'
);


--
-- Name: fin_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.fin_type_enum AS ENUM (
    'income',
    'expense'
);


--
-- Name: gender_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.gender_enum AS ENUM (
    'M',
    'F'
);


--
-- Name: invoice_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_status_enum AS ENUM (
    'issued',
    'paid',
    'overdue',
    'void'
);


--
-- Name: payment_method_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.payment_method_enum AS ENUM (
    'cash',
    'bank',
    'online'
);


--
-- Name: person_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.person_type_enum AS ENUM (
    'Player',
    'Staff'
);


--
-- Name: reg_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.reg_status_enum AS ENUM (
    'Draft',
    'Ready',
    'Submitted'
);


--
-- Name: request_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.request_type_enum AS ENUM (
    'New',
    'Transfer',
    'Renewal'
);


--
-- Name: sub_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.sub_status_enum AS ENUM (
    'active',
    'past_due',
    'canceled',
    'trial'
);


--
-- Name: enforce_single_club_owner(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enforce_single_club_owner() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_club_id bigint;
  v_cnt int;
BEGIN
  IF (SELECT name FROM roles WHERE id = NEW.role_id) <> 'ClubOwner' THEN
    RETURN NEW;
  END IF;

  SELECT club_id INTO v_club_id FROM users WHERE id = NEW.user_id;

  SELECT COUNT(*) INTO v_cnt
  FROM user_roles ur
  JOIN users u ON u.id = ur.user_id
  JOIN roles r ON r.id = ur.role_id
  WHERE r.name = 'ClubOwner'
    AND u.club_id = v_club_id
    AND (TG_OP = 'INSERT' OR ur.user_id <> NEW.user_id);

  IF v_cnt >= 1 THEN
    RAISE EXCEPTION 'Club % already has a ClubOwner', v_club_id
      USING ERRCODE = '23514';
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: touch_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.touch_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at := timezone('utc', now());
  RETURN NEW;
END $$;


--
-- Name: trg_block_lineup_items_when_locked(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trg_block_lineup_items_when_locked() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
      v_lineup_id bigint;
      v_status text;
    BEGIN
      -- Determine lineup_id depending on operation
      IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        v_lineup_id := NEW.lineup_id;
      ELSE
        v_lineup_id := OLD.lineup_id;
      END IF;

      SELECT status
        INTO v_status
      FROM public.event_lineups
      WHERE id = v_lineup_id;

      -- If parent lineup is missing, fail fast (integrity)
      IF v_status IS NULL THEN
        RAISE EXCEPTION 'Parent event_lineups not found for lineup_id=%', v_lineup_id
          USING ERRCODE = 'P0001';
      END IF;

      -- Block any modifications when locked
      IF v_status = 'Locked' THEN
        RAISE EXCEPTION 'Spisak je zaključan; izmjene nisu dozvoljene (lineup_id=%).', v_lineup_id
          USING ERRCODE = 'P0001';
      END IF;

      -- Allowed
      IF TG_OP = 'DELETE' THEN
        RETURN OLD;
      END IF;

      RETURN NEW;
    END;
    $$;


--
-- Name: tsm_set_club_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsm_set_club_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Uvijek povuci club_id iz teams, ignoriši input
  SELECT t.club_id INTO NEW.club_id
  FROM teams t
  WHERE t.id = NEW.team_id;

  IF NEW.club_id IS NULL THEN
    RAISE EXCEPTION 'team % nema club_id ili ne postoji', NEW.team_id;
  END IF;

  RETURN NEW;
END $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);


--
-- Name: app_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_settings (
    id bigint NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value character varying(200) NOT NULL
);


--
-- Name: app_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_settings_id_seq OWNED BY public.app_settings.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    user_id bigint,
    club_id bigint NOT NULL,
    action character varying(100) NOT NULL,
    entity character varying(50),
    entity_id bigint,
    ip character varying(45),
    user_agent character varying(200),
    metadata jsonb,
    result character varying(20) DEFAULT 'Success'::character varying NOT NULL,
    request_id character varying(100),
    CONSTRAINT audit_logs_result_chk CHECK (((result)::text = ANY ((ARRAY['Success'::character varying, 'Failed'::character varying, 'Denied'::character varying])::text[])))
);

ALTER TABLE ONLY public.audit_logs FORCE ROW LEVEL SECURITY;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: club_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.club_features (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    feature_key character varying(80) NOT NULL,
    feature_value character varying(80) NOT NULL
);

ALTER TABLE ONLY public.club_features FORCE ROW LEVEL SECURITY;


--
-- Name: club_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.club_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: club_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.club_features_id_seq OWNED BY public.club_features.id;


--
-- Name: club_officials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.club_officials (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    full_name character varying(120) NOT NULL,
    function character varying(80) NOT NULL,
    mobile character varying(50),
    phone character varying(50),
    fax character varying(50),
    email character varying(120),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_legal_representative boolean DEFAULT false NOT NULL,
    sort_order integer
);

ALTER TABLE ONLY public.club_officials FORCE ROW LEVEL SECURITY;


--
-- Name: club_officials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.club_officials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: club_officials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.club_officials_id_seq OWNED BY public.club_officials.id;


--
-- Name: clubs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clubs (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    short_name character varying(50),
    mailing_address character varying(200),
    city character varying(100),
    zip_code character varying(12),
    country character varying(2) DEFAULT 'BA'::character varying,
    phone character varying(50),
    fax character varying(50),
    mobile character varying(50),
    email character varying(120),
    website character varying(150),
    status text DEFAULT 'Active'::text NOT NULL,
    federation_code character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    deleted_at timestamp with time zone,
    logo_url character varying(300),
    registration_number character varying(50),
    vat_number character varying(50),
    bank_account character varying(50),
    bank_name character varying(100),
    billing_address character varying(200),
    CONSTRAINT chk_clubs_status CHECK ((status = ANY (ARRAY['Active'::text, 'Inactive'::text, 'Closing'::text]))),
    CONSTRAINT clubs_logo_url_format_chk CHECK (((logo_url IS NULL) OR ((logo_url)::text ~ '^clubs/.+'::text)))
);


--
-- Name: COLUMN clubs.logo_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clubs.logo_url IS 'Club crest/logo URL (absolute https:// or relative /path).';


--
-- Name: clubs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clubs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clubs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clubs_id_seq OWNED BY public.clubs.id;


--
-- Name: contracts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contracts (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    person_type text NOT NULL,
    person_id bigint NOT NULL,
    team_id bigint,
    document_type text NOT NULL,
    contract_kind text,
    contract_number text,
    signed_at date,
    start_date date NOT NULL,
    end_date date,
    termination_date date,
    parent_contract_id bigint,
    previous_contract_id bigint,
    federation_verified boolean DEFAULT false NOT NULL,
    federation_verified_at date,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_contracts_annex_parent CHECK ((((document_type = 'Annex'::text) AND (parent_contract_id IS NOT NULL)) OR ((document_type = 'Contract'::text) AND (parent_contract_id IS NULL)))),
    CONSTRAINT chk_contracts_contract_kind CHECK (((contract_kind IS NULL) OR (contract_kind = ANY (ARRAY['Professional'::text, 'Amateur'::text, 'Scholarship'::text, 'Volunteer'::text, 'Service'::text, 'Other'::text])))),
    CONSTRAINT chk_contracts_dates CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT chk_contracts_document_type CHECK ((document_type = ANY (ARRAY['Contract'::text, 'Annex'::text]))),
    CONSTRAINT chk_contracts_no_self_parent CHECK (((parent_contract_id IS NULL) OR (parent_contract_id <> id))),
    CONSTRAINT chk_contracts_no_self_previous CHECK (((previous_contract_id IS NULL) OR (previous_contract_id <> id))),
    CONSTRAINT chk_contracts_person_type CHECK ((person_type = ANY (ARRAY['Player'::text, 'Staff'::text]))),
    CONSTRAINT chk_contracts_termination_date CHECK (((termination_date IS NULL) OR (termination_date >= start_date))),
    CONSTRAINT chk_contracts_termination_vs_end CHECK (((termination_date IS NULL) OR (end_date IS NULL) OR (termination_date <= end_date))),
    CONSTRAINT chk_contracts_verified_date CHECK (((federation_verified = false) OR (federation_verified_at IS NOT NULL)))
);


--
-- Name: contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    entity text NOT NULL,
    entity_id bigint NOT NULL,
    file_name character varying(255) NOT NULL,
    content_type character varying(120) NOT NULL,
    size_bytes bigint NOT NULL,
    storage_path text,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    uploaded_by bigint,
    document_type text NOT NULL,
    file_extension text NOT NULL,
    expires_at timestamp with time zone,
    notes text,
    is_active boolean DEFAULT true NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    purged_at timestamp with time zone,
    replaced_by_document_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    document_title text NOT NULL,
    CONSTRAINT chk_documents_deleted_at CHECK ((((is_deleted = false) AND (deleted_at IS NULL)) OR (is_deleted = true))),
    CONSTRAINT chk_documents_deleted_state CHECK ((NOT ((is_deleted = true) AND (is_active = true)))),
    CONSTRAINT chk_documents_document_type CHECK ((document_type = ANY (ARRAY['IdentityDocument'::text, 'BirthDocument'::text, 'ParentConsent'::text, 'RegistrationDocument'::text, 'TransferDocument'::text, 'ContractDocument'::text, 'QualificationDocument'::text, 'MedicalDocument'::text, 'OfficialDocument'::text, 'Other'::text]))),
    CONSTRAINT chk_documents_entity CHECK ((entity = ANY (ARRAY['Player'::text, 'Staff'::text]))),
    CONSTRAINT chk_documents_file_extension CHECK ((lower(file_extension) = ANY (ARRAY['pdf'::text, 'jpg'::text, 'jpeg'::text, 'png'::text, 'docx'::text]))),
    CONSTRAINT chk_documents_purged_state CHECK (((purged_at IS NULL) OR (storage_path IS NULL))),
    CONSTRAINT chk_documents_title_not_empty CHECK ((length(TRIM(BOTH FROM document_title)) > 0))
);

ALTER TABLE ONLY public.documents FORCE ROW LEVEL SECURITY;


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: event_attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_attendance (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    person_type text NOT NULL,
    person_id bigint NOT NULL,
    status text NOT NULL,
    comment text,
    CONSTRAINT chk_event_attendance_person_type CHECK (((person_type IS NOT NULL) AND (lower(person_type) = ANY (ARRAY['player'::text, 'staff'::text])))),
    CONSTRAINT chk_event_attendance_status CHECK ((status = ANY (ARRAY['Unknown'::text, 'Present'::text, 'Absent'::text, 'Excused'::text])))
);


--
-- Name: event_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_attendance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_attendance_id_seq OWNED BY public.event_attendance.id;


--
-- Name: event_lineup_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_lineup_items (
    id bigint NOT NULL,
    lineup_id bigint NOT NULL,
    jersey_number text,
    role text,
    is_captain boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    player_name_snapshot text DEFAULT ''::text NOT NULL,
    person_type text NOT NULL,
    person_id bigint NOT NULL,
    CONSTRAINT chk_event_lineup_items_person_type CHECK ((person_type = ANY (ARRAY['player'::text, 'staff'::text]))),
    CONSTRAINT event_lineup_items_jersey_chk CHECK (((jersey_number IS NULL) OR (char_length(jersey_number) <= 4)))
);


--
-- Name: event_lineup_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.event_lineup_items ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.event_lineup_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event_lineups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_lineups (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    event_id bigint NOT NULL,
    team_id bigint NOT NULL,
    status text DEFAULT 'Draft'::text NOT NULL,
    locked_at timestamp with time zone,
    locked_by bigint,
    unlock_count integer DEFAULT 0 NOT NULL,
    last_unlock_reason text,
    modified_after_lock boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT event_lineups_status_chk CHECK ((status = ANY (ARRAY['Draft'::text, 'Locked'::text])))
);


--
-- Name: event_lineups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.event_lineups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.event_lineups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    type text NOT NULL,
    team_id bigint,
    season_id bigint,
    title character varying(120) NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    ends_at timestamp with time zone,
    location character varying(150),
    notes text,
    attendance_locked boolean DEFAULT false NOT NULL,
    attendance_locked_at timestamp with time zone,
    attendance_locked_by bigint,
    attendance_unlock_count integer DEFAULT 0 NOT NULL,
    attendance_last_unlock_reason text,
    attendance_modified_after_lock boolean DEFAULT false NOT NULL,
    opponent_name text,
    status text DEFAULT 'Scheduled'::text NOT NULL,
    status_changed_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    cancellation_reason text,
    CONSTRAINT chk_events_status CHECK ((status = ANY (ARRAY['Scheduled'::text, 'Cancelled'::text, 'Completed'::text]))),
    CONSTRAINT chk_events_type CHECK ((type = ANY (ARRAY['Training'::text, 'Match'::text, 'Meeting'::text])))
);

ALTER TABLE ONLY public.events FORCE ROW LEVEL SECURITY;


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: fee_invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fee_invoices (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    player_id bigint NOT NULL,
    period character varying(7) NOT NULL,
    issue_date date NOT NULL,
    due_date date NOT NULL,
    amount numeric(10,2) NOT NULL,
    status text DEFAULT 'Due'::public.fee_status_enum NOT NULL,
    period_seq integer NOT NULL,
    CONSTRAINT chk_fee_invoices_status CHECK ((status = ANY (ARRAY['Due'::text, 'Partial'::text, 'Paid'::text])))
);

ALTER TABLE ONLY public.fee_invoices FORCE ROW LEVEL SECURITY;


--
-- Name: fee_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fee_invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fee_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fee_invoices_id_seq OWNED BY public.fee_invoices.id;


--
-- Name: fee_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fee_payments (
    id bigint NOT NULL,
    fee_invoice_id bigint NOT NULL,
    paid_at timestamp with time zone NOT NULL,
    amount numeric(10,2) NOT NULL,
    method text,
    reference character varying(80),
    fin_transaction_id bigint,
    voided_at timestamp with time zone,
    voided_reason text,
    voided_fin_transaction_id bigint,
    note character varying(500),
    CONSTRAINT chk_fee_payments_method CHECK (((method IS NULL) OR (method = ANY (ARRAY['cash'::text, 'bank'::text, 'online'::text]))))
);


--
-- Name: fee_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fee_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fee_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fee_payments_id_seq OWNED BY public.fee_payments.id;


--
-- Name: fin_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fin_categories (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    type text NOT NULL,
    code character varying(40) NOT NULL,
    name character varying(100) NOT NULL,
    CONSTRAINT chk_fin_categories_type CHECK ((type = ANY (ARRAY['income'::text, 'expense'::text])))
);

ALTER TABLE ONLY public.fin_categories FORCE ROW LEVEL SECURITY;


--
-- Name: fin_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fin_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fin_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fin_categories_id_seq OWNED BY public.fin_categories.id;


--
-- Name: fin_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fin_transactions (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    date date NOT NULL,
    type text NOT NULL,
    category_id bigint,
    description text,
    amount numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    external boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_fin_transactions_external_expense CHECK (((NOT external) OR (type = 'expense'::text))),
    CONSTRAINT chk_fin_transactions_type CHECK ((type = ANY (ARRAY['income'::text, 'expense'::text])))
);

ALTER TABLE ONLY public.fin_transactions FORCE ROW LEVEL SECURITY;


--
-- Name: fin_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fin_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fin_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fin_transactions_id_seq OWNED BY public.fin_transactions.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    subscription_id bigint,
    number character varying(50) NOT NULL,
    issue_date date NOT NULL,
    due_date date NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character(3) DEFAULT 'BAM'::bpchar NOT NULL,
    status text NOT NULL,
    notes text,
    CONSTRAINT chk_invoices_status CHECK ((status = ANY (ARRAY['issued'::text, 'paid'::text, 'overdue'::text, 'void'::text])))
);

ALTER TABLE ONLY public.invoices FORCE ROW LEVEL SECURITY;


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: password_resets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_resets (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    purpose text NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT password_resets_purpose_check CHECK ((purpose = ANY (ARRAY['invite'::text, 'reset'::text])))
);

ALTER TABLE ONLY public.password_resets FORCE ROW LEVEL SECURITY;


--
-- Name: password_resets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.password_resets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: password_resets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.password_resets_id_seq OWNED BY public.password_resets.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    invoice_id bigint NOT NULL,
    paid_at timestamp with time zone NOT NULL,
    amount numeric(12,2) NOT NULL,
    method text,
    reference character varying(80),
    club_id bigint NOT NULL,
    CONSTRAINT chk_payments_method CHECK (((method IS NULL) OR (method = ANY (ARRAY['cash'::text, 'bank'::text, 'online'::text])))),
    CONSTRAINT ck_payments_amount_positive CHECK ((amount > (0)::numeric))
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    key character varying(80) NOT NULL,
    description character varying(200)
);


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: plan_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plan_features (
    id bigint NOT NULL,
    plan_id bigint NOT NULL,
    feature_key character varying(80) NOT NULL,
    feature_value character varying(80) NOT NULL
);


--
-- Name: plan_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plan_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plan_features_id_seq OWNED BY public.plan_features.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plans (
    id bigint NOT NULL,
    code character varying(40) NOT NULL,
    name character varying(80) NOT NULL,
    price_month numeric(12,2) NOT NULL,
    currency character(3) DEFAULT 'BAM'::bpchar NOT NULL,
    billing_cycle text DEFAULT 'monthly'::text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT chk_plans_billing_cycle CHECK ((billing_cycle = ANY (ARRAY['monthly'::text, 'yearly'::text])))
);


--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: player_medicals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.player_medicals (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    player_id bigint NOT NULL,
    exam_date date NOT NULL,
    valid_until date NOT NULL,
    document_id bigint,
    notes text,
    exam_type text,
    result text,
    doctor_name character varying(120),
    clinic_name character varying(120),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT player_medicals_exam_type_check CHECK (((exam_type IS NULL) OR (exam_type = ANY (ARRAY['general'::text, 'cardio'::text, 'return_to_play'::text])))),
    CONSTRAINT player_medicals_result_check CHECK (((result IS NULL) OR (result = ANY (ARRAY['Cleared'::text, 'Limited'::text, 'NotCleared'::text]))))
);

ALTER TABLE ONLY public.player_medicals FORCE ROW LEVEL SECURITY;


--
-- Name: player_medicals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.player_medicals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: player_medicals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.player_medicals_id_seq OWNED BY public.player_medicals.id;


--
-- Name: player_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.player_registrations (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    player_id bigint NOT NULL,
    season_id bigint NOT NULL,
    registered_at date NOT NULL,
    valid_from date NOT NULL,
    valid_until date NOT NULL,
    status text DEFAULT 'Active'::text NOT NULL,
    registration_type text,
    federation_number character varying(50),
    competition_level text,
    contract_id bigint,
    package_id bigint,
    approved_by bigint,
    approved_at timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT player_registrations_registration_type_check CHECK ((registration_type = ANY (ARRAY['first'::text, 'renewal'::text, 'transfer'::text, 'dual'::text, 'loan'::text]))),
    CONSTRAINT player_registrations_status_check CHECK ((status = ANY (ARRAY['Active'::text, 'Expired'::text, 'Canceled'::text])))
);

ALTER TABLE ONLY public.player_registrations FORCE ROW LEVEL SECURITY;


--
-- Name: player_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.player_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: player_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.player_registrations_id_seq OWNED BY public.player_registrations.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.players (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    jmbg character varying(13) NOT NULL,
    passport_number character varying(20),
    birth_date date NOT NULL,
    birth_place character varying(100),
    birth_country character varying(2),
    nationality character varying(50),
    sports_nationality character varying(50),
    gender text NOT NULL,
    height_cm integer,
    weight_kg integer,
    shirt_size character varying(10),
    shoe_size numeric(4,1),
    "position" character varying(20),
    phone character varying(50),
    email character varying(120),
    photo_url text,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id bigint,
    CONSTRAINT chk_players_gender CHECK ((gender = ANY (ARRAY['M'::text, 'F'::text])))
);

ALTER TABLE ONLY public.players FORCE ROW LEVEL SECURITY;


--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.players_id_seq OWNED BY public.players.id;


--
-- Name: registration_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registration_items (
    id bigint NOT NULL,
    package_id bigint NOT NULL,
    name character varying(80) NOT NULL,
    mode character varying(20) NOT NULL,
    is_provided boolean DEFAULT false NOT NULL,
    document_id bigint,
    notes text
);


--
-- Name: registration_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registration_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registration_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registration_items_id_seq OWNED BY public.registration_items.id;


--
-- Name: registration_packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registration_packages (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    entity_type text NOT NULL,
    entity_id bigint NOT NULL,
    season_id bigint NOT NULL,
    request_type text NOT NULL,
    status text DEFAULT 'Draft'::public.reg_status_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_registration_packages_entity_type CHECK ((entity_type = ANY (ARRAY['Player'::text, 'Staff'::text]))),
    CONSTRAINT chk_registration_packages_request_type CHECK ((request_type = ANY (ARRAY['New'::text, 'Transfer'::text, 'Renewal'::text]))),
    CONSTRAINT chk_registration_packages_status CHECK ((status = ANY (ARRAY['Draft'::text, 'Ready'::text, 'Submitted'::text])))
);

ALTER TABLE ONLY public.registration_packages FORCE ROW LEVEL SECURITY;


--
-- Name: registration_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registration_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registration_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registration_packages_id_seq OWNED BY public.registration_packages.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200)
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons (
    id bigint NOT NULL,
    name character varying(20) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_default boolean DEFAULT false NOT NULL
);


--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seasons_id_seq OWNED BY public.seasons.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    scope character varying(20) NOT NULL,
    club_id bigint NOT NULL,
    key character varying(80) NOT NULL,
    value text NOT NULL
);

ALTER TABLE ONLY public.settings FORCE ROW LEVEL SECURITY;


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staff (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    jmbg character varying(13) NOT NULL,
    passport_number character varying(20),
    birth_date date,
    birth_place character varying(100),
    birth_country character varying(2),
    nationality character varying(50),
    gender text,
    role character varying(50) NOT NULL,
    academic_title character varying(50),
    qualification character varying(100),
    phone character varying(50),
    email character varying(120),
    photo_url text,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_staff_gender CHECK ((gender = ANY (ARRAY['M'::text, 'F'::text])))
);

ALTER TABLE ONLY public.staff FORCE ROW LEVEL SECURITY;


--
-- Name: staff_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.staff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.staff_id_seq OWNED BY public.staff.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    plan_id bigint NOT NULL,
    status text NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    renews_at timestamp with time zone,
    ends_at timestamp with time zone,
    trial_ends_at timestamp with time zone,
    CONSTRAINT chk_subscriptions_status CHECK ((status = ANY (ARRAY['active'::text, 'past_due'::text, 'canceled'::text, 'trial'::text])))
);

ALTER TABLE ONLY public.subscriptions FORCE ROW LEVEL SECURITY;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: team_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_memberships (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    player_id bigint NOT NULL,
    season_id bigint,
    jersey_number integer,
    preferred_position character varying(20),
    joined_at date,
    left_at date,
    fee_included boolean DEFAULT false NOT NULL
);


--
-- Name: team_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_memberships_id_seq OWNED BY public.team_memberships.id;


--
-- Name: team_staff_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_staff_memberships (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    team_id bigint NOT NULL,
    staff_id bigint NOT NULL,
    role text NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    start_date date NOT NULL,
    end_date date,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT team_staff_memberships_role_check CHECK ((role = ANY (ARRAY['HeadCoach'::text, 'AssistantCoach'::text, 'Manager'::text, 'Physio'::text, 'Analyst'::text])))
);


--
-- Name: team_staff_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_staff_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_staff_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_staff_memberships_id_seq OWNED BY public.team_staff_memberships.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    club_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50),
    gender text NOT NULL,
    coach_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    assistant_coach_id bigint,
    CONSTRAINT chk_teams_gender CHECK ((gender = ANY (ARRAY['M'::text, 'F'::text]))),
    CONSTRAINT teams_gender_chk CHECK ((gender = ANY (ARRAY['M'::text, 'F'::text])))
);

ALTER TABLE ONLY public.teams FORCE ROW LEVEL SECURITY;


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_roles (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    club_id bigint,
    email character varying(150) NOT NULL,
    password_hash character varying(255),
    first_name character varying(60),
    last_name character varying(60),
    phone character varying(40),
    is_active boolean DEFAULT true NOT NULL,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_password_hash_bcrypt_chk CHECK (((password_hash IS NULL) OR ((password_hash)::text ~ '^\$(2a|2b|2y)\$\d{2}\$[./A-Za-z0-9]{53}$'::text)))
);

ALTER TABLE ONLY public.users FORCE ROW LEVEL SECURITY;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: app_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_settings ALTER COLUMN id SET DEFAULT nextval('public.app_settings_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: club_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_features ALTER COLUMN id SET DEFAULT nextval('public.club_features_id_seq'::regclass);


--
-- Name: club_officials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_officials ALTER COLUMN id SET DEFAULT nextval('public.club_officials_id_seq'::regclass);


--
-- Name: clubs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clubs ALTER COLUMN id SET DEFAULT nextval('public.clubs_id_seq'::regclass);


--
-- Name: contracts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: event_attendance id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendance ALTER COLUMN id SET DEFAULT nextval('public.event_attendance_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: fee_invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_invoices ALTER COLUMN id SET DEFAULT nextval('public.fee_invoices_id_seq'::regclass);


--
-- Name: fee_payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_payments ALTER COLUMN id SET DEFAULT nextval('public.fee_payments_id_seq'::regclass);


--
-- Name: fin_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_categories ALTER COLUMN id SET DEFAULT nextval('public.fin_categories_id_seq'::regclass);


--
-- Name: fin_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_transactions ALTER COLUMN id SET DEFAULT nextval('public.fin_transactions_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: password_resets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets ALTER COLUMN id SET DEFAULT nextval('public.password_resets_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: plan_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan_features ALTER COLUMN id SET DEFAULT nextval('public.plan_features_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: player_medicals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_medicals ALTER COLUMN id SET DEFAULT nextval('public.player_medicals_id_seq'::regclass);


--
-- Name: player_registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_registrations ALTER COLUMN id SET DEFAULT nextval('public.player_registrations_id_seq'::regclass);


--
-- Name: players id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players ALTER COLUMN id SET DEFAULT nextval('public.players_id_seq'::regclass);


--
-- Name: registration_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_items ALTER COLUMN id SET DEFAULT nextval('public.registration_items_id_seq'::regclass);


--
-- Name: registration_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_packages ALTER COLUMN id SET DEFAULT nextval('public.registration_packages_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: seasons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons ALTER COLUMN id SET DEFAULT nextval('public.seasons_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: staff id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff ALTER COLUMN id SET DEFAULT nextval('public.staff_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: team_memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships ALTER COLUMN id SET DEFAULT nextval('public.team_memberships_id_seq'::regclass);


--
-- Name: team_staff_memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_staff_memberships ALTER COLUMN id SET DEFAULT nextval('public.team_staff_memberships_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- Name: app_settings app_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_settings
    ADD CONSTRAINT app_settings_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: club_features club_features_club_id_feature_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_features
    ADD CONSTRAINT club_features_club_id_feature_key_key UNIQUE (club_id, feature_key);


--
-- Name: club_features club_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_features
    ADD CONSTRAINT club_features_pkey PRIMARY KEY (id);


--
-- Name: club_officials club_officials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_officials
    ADD CONSTRAINT club_officials_pkey PRIMARY KEY (id);


--
-- Name: clubs clubs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT clubs_pkey PRIMARY KEY (id);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: event_attendance event_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT event_attendance_pkey PRIMARY KEY (id);


--
-- Name: event_lineup_items event_lineup_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineup_items
    ADD CONSTRAINT event_lineup_items_pkey PRIMARY KEY (id);


--
-- Name: event_lineups event_lineups_event_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineups
    ADD CONSTRAINT event_lineups_event_id_key UNIQUE (event_id);


--
-- Name: event_lineups event_lineups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineups
    ADD CONSTRAINT event_lineups_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: team_staff_memberships ex_tsm_primary_headcoach_no_overlap; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_staff_memberships
    ADD CONSTRAINT ex_tsm_primary_headcoach_no_overlap EXCLUDE USING gist (team_id WITH =, daterange(start_date, COALESCE(end_date, 'infinity'::date), '[]'::text) WITH &&) WHERE (((role = 'HeadCoach'::text) AND (is_primary = true)));


--
-- Name: fee_invoices fee_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_invoices
    ADD CONSTRAINT fee_invoices_pkey PRIMARY KEY (id);


--
-- Name: fee_invoices fee_invoices_player_id_period_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_invoices
    ADD CONSTRAINT fee_invoices_player_id_period_key UNIQUE (player_id, period);


--
-- Name: fee_payments fee_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_payments
    ADD CONSTRAINT fee_payments_pkey PRIMARY KEY (id);


--
-- Name: fin_categories fin_categories_club_id_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_categories
    ADD CONSTRAINT fin_categories_club_id_code_key UNIQUE (club_id, code);


--
-- Name: fin_categories fin_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_categories
    ADD CONSTRAINT fin_categories_pkey PRIMARY KEY (id);


--
-- Name: fin_transactions fin_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_transactions
    ADD CONSTRAINT fin_transactions_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_club_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_club_number_key UNIQUE (club_id, number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: password_resets password_resets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_pkey PRIMARY KEY (id);


--
-- Name: password_resets password_resets_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_token_hash_key UNIQUE (token_hash);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_key_key UNIQUE (key);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: plan_features plan_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan_features
    ADD CONSTRAINT plan_features_pkey PRIMARY KEY (id);


--
-- Name: plan_features plan_features_plan_id_feature_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan_features
    ADD CONSTRAINT plan_features_plan_id_feature_key_key UNIQUE (plan_id, feature_key);


--
-- Name: plans plans_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_code_key UNIQUE (code);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: player_medicals player_medicals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_medicals
    ADD CONSTRAINT player_medicals_pkey PRIMARY KEY (id);


--
-- Name: player_registrations player_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_registrations
    ADD CONSTRAINT player_registrations_pkey PRIMARY KEY (id);


--
-- Name: players players_club_id_jmbg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_club_id_jmbg_key UNIQUE (club_id, jmbg);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: registration_items registration_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_items
    ADD CONSTRAINT registration_items_pkey PRIMARY KEY (id);


--
-- Name: registration_packages registration_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_packages
    ADD CONSTRAINT registration_packages_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: settings settings_scope_club_id_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_scope_club_id_key_key UNIQUE (scope, club_id, key);


--
-- Name: staff staff_club_id_jmbg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_club_id_jmbg_key UNIQUE (club_id, jmbg);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: team_memberships team_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_pkey PRIMARY KEY (id);


--
-- Name: team_staff_memberships team_staff_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_staff_memberships
    ADD CONSTRAINT team_staff_memberships_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: event_attendance uq_event_attendance_event_person; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT uq_event_attendance_event_person UNIQUE (event_id, person_type, person_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: fee_invoices ux_fee_invoices_period_seq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_invoices
    ADD CONSTRAINT ux_fee_invoices_period_seq UNIQUE (club_id, period, period_seq);


--
-- Name: idx_fee_invoices_period_seq; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fee_invoices_period_seq ON public.fee_invoices USING btree (club_id, period, period_seq);


--
-- Name: idx_fee_payments_fin_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fee_payments_fin_transaction_id ON public.fee_payments USING btree (fin_transaction_id);


--
-- Name: idx_player_medicals_player; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_player_medicals_player ON public.player_medicals USING btree (club_id, player_id, valid_until DESC, exam_date DESC);


--
-- Name: idx_player_registrations_base; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_player_registrations_base ON public.player_registrations USING btree (club_id, player_id, season_id);


--
-- Name: idx_tsm_staff; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tsm_staff ON public.team_staff_memberships USING btree (staff_id);


--
-- Name: idx_tsm_team_role_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tsm_team_role_dates ON public.team_staff_memberships USING btree (team_id, role, start_date, end_date);


--
-- Name: ix_audit_club_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_audit_club_time ON public.audit_logs USING btree (club_id, "timestamp" DESC);


--
-- Name: ix_audit_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_audit_time ON public.audit_logs USING btree ("timestamp" DESC);


--
-- Name: ix_audit_user_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_audit_user_time ON public.audit_logs USING btree (user_id, "timestamp" DESC);


--
-- Name: ix_club_officials_club; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_club_officials_club ON public.club_officials USING btree (club_id);


--
-- Name: ix_club_officials_legal_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_club_officials_legal_rep ON public.club_officials USING btree (club_id) WHERE (is_legal_representative = true);


--
-- Name: ix_clubs_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_clubs_is_active ON public.clubs USING btree (is_active);


--
-- Name: ix_contracts_club_document_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_club_document_type ON public.contracts USING btree (club_id, document_type);


--
-- Name: ix_contracts_club_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_club_person ON public.contracts USING btree (club_id, person_type, person_id);


--
-- Name: ix_contracts_club_person_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_club_person_dates ON public.contracts USING btree (club_id, person_type, person_id, start_date, end_date);


--
-- Name: ix_contracts_contract_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_contract_number ON public.contracts USING btree (club_id, contract_number);


--
-- Name: ix_contracts_federation_verified; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_federation_verified ON public.contracts USING btree (club_id, federation_verified);


--
-- Name: ix_contracts_parent_contract; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_parent_contract ON public.contracts USING btree (parent_contract_id);


--
-- Name: ix_contracts_previous_contract; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_previous_contract ON public.contracts USING btree (previous_contract_id);


--
-- Name: ix_contracts_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contracts_team ON public.contracts USING btree (team_id);


--
-- Name: ix_documents_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_documents_active ON public.documents USING btree (club_id, is_active, is_deleted);


--
-- Name: ix_documents_club_entity_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_documents_club_entity_lookup ON public.documents USING btree (club_id, entity, entity_id);


--
-- Name: ix_documents_club_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_documents_club_time ON public.documents USING btree (club_id, uploaded_at DESC);


--
-- Name: ix_documents_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_documents_entity ON public.documents USING btree (entity, entity_id);


--
-- Name: ix_documents_replaced_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_documents_replaced_by ON public.documents USING btree (replaced_by_document_id);


--
-- Name: ix_documents_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_documents_type ON public.documents USING btree (club_id, document_type);


--
-- Name: ix_event_attendance_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_event_attendance_event ON public.event_attendance USING btree (event_id);


--
-- Name: ix_event_attendance_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_event_attendance_person ON public.event_attendance USING btree (person_type, person_id);


--
-- Name: ix_event_lineup_items_lineup_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_event_lineup_items_lineup_sort ON public.event_lineup_items USING btree (lineup_id, sort_order);


--
-- Name: ix_event_lineup_items_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_event_lineup_items_person ON public.event_lineup_items USING btree (person_type, person_id);


--
-- Name: ix_event_lineups_club; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_event_lineups_club ON public.event_lineups USING btree (club_id);


--
-- Name: ix_event_lineups_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_event_lineups_team ON public.event_lineups USING btree (team_id);


--
-- Name: ix_events_attendance_locked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_events_attendance_locked ON public.events USING btree (attendance_locked);


--
-- Name: ix_events_attendance_locked_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_events_attendance_locked_by ON public.events USING btree (attendance_locked_by);


--
-- Name: ix_events_club_status_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_events_club_status_time ON public.events USING btree (club_id, status, starts_at);


--
-- Name: ix_events_club_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_events_club_time ON public.events USING btree (club_id, starts_at);


--
-- Name: ix_fee_invoices_club_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_fee_invoices_club_period ON public.fee_invoices USING btree (club_id, period);


--
-- Name: ix_fee_payments_invoice; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_fee_payments_invoice ON public.fee_payments USING btree (fee_invoice_id);


--
-- Name: ix_fin_tx_club_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_fin_tx_club_date ON public.fin_transactions USING btree (club_id, date);


--
-- Name: ix_invoices_club; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_invoices_club ON public.invoices USING btree (club_id);


--
-- Name: ix_invoices_club_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_invoices_club_status ON public.invoices USING btree (club_id, status);


--
-- Name: ix_password_resets_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_password_resets_expires ON public.password_resets USING btree (expires_at);


--
-- Name: ix_password_resets_user_used; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_password_resets_user_used ON public.password_resets USING btree (user_id, used_at);


--
-- Name: ix_payments_club_paidat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_payments_club_paidat ON public.payments USING btree (club_id, paid_at DESC);


--
-- Name: ix_payments_invoice; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_payments_invoice ON public.payments USING btree (invoice_id);


--
-- Name: ix_payments_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_payments_invoice_id ON public.payments USING btree (invoice_id);


--
-- Name: ix_players_club_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_players_club_name ON public.players USING btree (club_id, last_name, first_name);


--
-- Name: ix_reg_items_package; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reg_items_package ON public.registration_items USING btree (package_id);


--
-- Name: ix_reg_packages_club; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reg_packages_club ON public.registration_packages USING btree (club_id, season_id);


--
-- Name: ix_staff_club_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_staff_club_name ON public.staff USING btree (club_id, last_name, first_name);


--
-- Name: ix_subscriptions_club; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_subscriptions_club ON public.subscriptions USING btree (club_id);


--
-- Name: ix_subscriptions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_subscriptions_status ON public.subscriptions USING btree (status);


--
-- Name: ix_team_memberships_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_memberships_team ON public.team_memberships USING btree (team_id, season_id);


--
-- Name: ix_teams_assistant_coach; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_teams_assistant_coach ON public.teams USING btree (assistant_coach_id);


--
-- Name: ix_teams_club; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_teams_club ON public.teams USING btree (club_id);


--
-- Name: ix_teams_coach; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_teams_coach ON public.teams USING btree (coach_id);


--
-- Name: ix_users_club; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_club ON public.users USING btree (club_id);


--
-- Name: uniq_player_registration_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_player_registration_active ON public.player_registrations USING btree (club_id, player_id, season_id) WHERE (status = 'Active'::text);


--
-- Name: ux_app_settings_setting_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_app_settings_setting_key ON public.app_settings USING btree (setting_key);


--
-- Name: ux_contracts_club_contract_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_contracts_club_contract_number ON public.contracts USING btree (club_id, contract_number) WHERE (contract_number IS NOT NULL);


--
-- Name: ux_documents_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_documents_id_club ON public.documents USING btree (id, club_id);


--
-- Name: ux_documents_single_active_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_documents_single_active_type ON public.documents USING btree (club_id, entity, entity_id, document_type) WHERE ((is_active = true) AND (is_deleted = false) AND (document_type <> ALL (ARRAY['OfficialDocument'::text, 'Other'::text])));


--
-- Name: ux_event_lineup_items_lineup_person; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_event_lineup_items_lineup_person ON public.event_lineup_items USING btree (lineup_id, person_type, person_id);


--
-- Name: ux_events_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_events_id_club ON public.events USING btree (id, club_id);


--
-- Name: ux_fee_invoices_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_fee_invoices_id_club ON public.fee_invoices USING btree (id, club_id);


--
-- Name: ux_fin_categories_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_fin_categories_id_club ON public.fin_categories USING btree (id, club_id);


--
-- Name: ux_invoices_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_invoices_id_club ON public.invoices USING btree (id, club_id);


--
-- Name: ux_players_club_jmbg; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_players_club_jmbg ON public.players USING btree (club_id, jmbg);


--
-- Name: ux_players_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_players_id_club ON public.players USING btree (id, club_id);


--
-- Name: ux_players_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_players_user_id ON public.players USING btree (user_id) WHERE (user_id IS NOT NULL);


--
-- Name: ux_registration_packages_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_registration_packages_id_club ON public.registration_packages USING btree (id, club_id);


--
-- Name: ux_staff_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_staff_id_club ON public.staff USING btree (id, club_id);


--
-- Name: ux_subscriptions_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_subscriptions_id_club ON public.subscriptions USING btree (id, club_id);


--
-- Name: ux_subscriptions_one_active_per_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_subscriptions_one_active_per_club ON public.subscriptions USING btree (club_id) WHERE (status = ANY (ARRAY['trial'::text, 'active'::text, 'past_due'::text]));


--
-- Name: ux_team_memberships_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_team_memberships_active ON public.team_memberships USING btree (team_id, player_id, season_id) WHERE (left_at IS NULL);


--
-- Name: ux_team_memberships_active_jersey; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_team_memberships_active_jersey ON public.team_memberships USING btree (team_id, season_id, jersey_number) WHERE ((left_at = 'infinity'::date) AND (jersey_number IS NOT NULL));


--
-- Name: ux_team_memberships_active_team_player_season; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_team_memberships_active_team_player_season ON public.team_memberships USING btree (team_id, player_id, season_id) WHERE (left_at = 'infinity'::date);


--
-- Name: ux_teams_club_lname; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_teams_club_lname ON public.teams USING btree (club_id, lower((name)::text));


--
-- Name: ux_teams_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_teams_id_club ON public.teams USING btree (id, club_id);


--
-- Name: ux_tm_jersey_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_tm_jersey_active ON public.team_memberships USING btree (team_id, season_id, jersey_number) WHERE ((jersey_number IS NOT NULL) AND (left_at IS NULL));


--
-- Name: ux_tm_team_jersey_null_season; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_tm_team_jersey_null_season ON public.team_memberships USING btree (team_id, jersey_number) WHERE ((season_id IS NULL) AND (jersey_number IS NOT NULL));


--
-- Name: ux_tm_team_player_null_season; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_tm_team_player_null_season ON public.team_memberships USING btree (team_id, player_id) WHERE (season_id IS NULL);


--
-- Name: ux_tsm_team_staff_role_start; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_tsm_team_staff_role_start ON public.team_staff_memberships USING btree (team_id, staff_id, role, start_date);


--
-- Name: ux_users_id_club; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_users_id_club ON public.users USING btree (id, club_id);


--
-- Name: event_lineup_items tr_block_lineup_items_when_locked; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_block_lineup_items_when_locked BEFORE INSERT OR DELETE OR UPDATE ON public.event_lineup_items FOR EACH ROW EXECUTE FUNCTION public.trg_block_lineup_items_when_locked();


--
-- Name: user_roles trg_enforce_single_club_owner; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_enforce_single_club_owner BEFORE INSERT OR UPDATE ON public.user_roles FOR EACH ROW EXECUTE FUNCTION public.enforce_single_club_owner();


--
-- Name: team_staff_memberships trg_tsm_set_club_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_tsm_set_club_id BEFORE INSERT OR UPDATE OF team_id ON public.team_staff_memberships FOR EACH ROW EXECUTE FUNCTION public.tsm_set_club_id();


--
-- Name: team_staff_memberships trg_tsm_touch; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_tsm_touch BEFORE UPDATE ON public.team_staff_memberships FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- Name: audit_logs audit_logs_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: club_features club_features_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_features
    ADD CONSTRAINT club_features_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: club_officials club_officials_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_officials
    ADD CONSTRAINT club_officials_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: documents documents_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: documents documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_uploaded_by_fkey FOREIGN KEY (uploaded_by, club_id) REFERENCES public.users(id, club_id) ON DELETE SET NULL;


--
-- Name: event_attendance event_attendance_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT event_attendance_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_lineup_items event_lineup_items_lineup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineup_items
    ADD CONSTRAINT event_lineup_items_lineup_id_fkey FOREIGN KEY (lineup_id) REFERENCES public.event_lineups(id) ON DELETE CASCADE;


--
-- Name: event_lineups event_lineups_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineups
    ADD CONSTRAINT event_lineups_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: event_lineups event_lineups_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineups
    ADD CONSTRAINT event_lineups_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_lineups event_lineups_locked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineups
    ADD CONSTRAINT event_lineups_locked_by_fkey FOREIGN KEY (locked_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: event_lineups event_lineups_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_lineups
    ADD CONSTRAINT event_lineups_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE RESTRICT;


--
-- Name: events events_attendance_locked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_attendance_locked_by_fkey FOREIGN KEY (attendance_locked_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: events events_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: events events_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- Name: events events_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_team_id_fkey FOREIGN KEY (team_id, club_id) REFERENCES public.teams(id, club_id) ON DELETE RESTRICT;


--
-- Name: fee_invoices fee_invoices_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_invoices
    ADD CONSTRAINT fee_invoices_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: fee_invoices fee_invoices_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_invoices
    ADD CONSTRAINT fee_invoices_player_id_fkey FOREIGN KEY (player_id, club_id) REFERENCES public.players(id, club_id) ON DELETE RESTRICT;


--
-- Name: fee_payments fee_payments_fee_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_payments
    ADD CONSTRAINT fee_payments_fee_invoice_id_fkey FOREIGN KEY (fee_invoice_id) REFERENCES public.fee_invoices(id) ON DELETE CASCADE;


--
-- Name: fin_categories fin_categories_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_categories
    ADD CONSTRAINT fin_categories_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: fin_transactions fin_transactions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_transactions
    ADD CONSTRAINT fin_transactions_category_id_fkey FOREIGN KEY (category_id, club_id) REFERENCES public.fin_categories(id, club_id) ON DELETE SET NULL;


--
-- Name: fin_transactions fin_transactions_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fin_transactions
    ADD CONSTRAINT fin_transactions_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: contracts fk_contracts_club; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT fk_contracts_club FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: contracts fk_contracts_parent; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT fk_contracts_parent FOREIGN KEY (parent_contract_id) REFERENCES public.contracts(id) ON DELETE RESTRICT;


--
-- Name: contracts fk_contracts_previous; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT fk_contracts_previous FOREIGN KEY (previous_contract_id) REFERENCES public.contracts(id) ON DELETE RESTRICT;


--
-- Name: contracts fk_contracts_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT fk_contracts_team FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- Name: documents fk_documents_replaced_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT fk_documents_replaced_by FOREIGN KEY (replaced_by_document_id) REFERENCES public.documents(id) ON DELETE SET NULL;


--
-- Name: fee_payments fk_fee_payments_fin_transaction; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_payments
    ADD CONSTRAINT fk_fee_payments_fin_transaction FOREIGN KEY (fin_transaction_id) REFERENCES public.fin_transactions(id) ON DELETE RESTRICT;


--
-- Name: fee_payments fk_fee_payments_voided_fin_tx; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_payments
    ADD CONSTRAINT fk_fee_payments_voided_fin_tx FOREIGN KEY (voided_fin_transaction_id) REFERENCES public.fin_transactions(id) ON DELETE RESTRICT;


--
-- Name: payments fk_payments_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_invoice FOREIGN KEY (invoice_id, club_id) REFERENCES public.invoices(id, club_id) ON DELETE RESTRICT;


--
-- Name: players fk_players_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT fk_players_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: teams fk_teams_assistant_coach_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT fk_teams_assistant_coach_id FOREIGN KEY (assistant_coach_id) REFERENCES public.staff(id) ON DELETE SET NULL;


--
-- Name: teams fk_teams_club_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT fk_teams_club_id FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: invoices invoices_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE RESTRICT;


--
-- Name: invoices invoices_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_subscription_id_fkey FOREIGN KEY (subscription_id, club_id) REFERENCES public.subscriptions(id, club_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: password_resets password_resets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payments payments_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;


--
-- Name: plan_features plan_features_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan_features
    ADD CONSTRAINT plan_features_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON DELETE CASCADE;


--
-- Name: player_medicals player_medicals_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_medicals
    ADD CONSTRAINT player_medicals_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id);


--
-- Name: player_medicals player_medicals_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_medicals
    ADD CONSTRAINT player_medicals_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: player_medicals player_medicals_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_medicals
    ADD CONSTRAINT player_medicals_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id);


--
-- Name: player_registrations player_registrations_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_registrations
    ADD CONSTRAINT player_registrations_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id);


--
-- Name: player_registrations player_registrations_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_registrations
    ADD CONSTRAINT player_registrations_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id);


--
-- Name: player_registrations player_registrations_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_registrations
    ADD CONSTRAINT player_registrations_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(id);


--
-- Name: players players_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: registration_items registration_items_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_items
    ADD CONSTRAINT registration_items_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(id) ON DELETE SET NULL;


--
-- Name: registration_items registration_items_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_items
    ADD CONSTRAINT registration_items_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.registration_packages(id) ON DELETE CASCADE;


--
-- Name: registration_packages registration_packages_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_packages
    ADD CONSTRAINT registration_packages_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: registration_packages registration_packages_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_packages
    ADD CONSTRAINT registration_packages_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: settings settings_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: staff staff_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON DELETE RESTRICT;


--
-- Name: team_memberships team_memberships_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE CASCADE;


--
-- Name: team_memberships team_memberships_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- Name: team_memberships team_memberships_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: team_staff_memberships team_staff_memberships_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_staff_memberships
    ADD CONSTRAINT team_staff_memberships_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(id) ON DELETE RESTRICT;


--
-- Name: team_staff_memberships team_staff_memberships_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_staff_memberships
    ADD CONSTRAINT team_staff_memberships_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: teams teams_coach_id_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_coach_id_club_id_fkey FOREIGN KEY (coach_id, club_id) REFERENCES public.staff(id, club_id);


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_club_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_club_id_fkey FOREIGN KEY (club_id) REFERENCES public.clubs(id) ON DELETE SET NULL;


--
-- Name: audit_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: club_features; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.club_features ENABLE ROW LEVEL SECURITY;

--
-- Name: club_officials; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.club_officials ENABLE ROW LEVEL SECURITY;

--
-- Name: documents; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

--
-- Name: event_lineup_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.event_lineup_items ENABLE ROW LEVEL SECURITY;

--
-- Name: event_lineups; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.event_lineups ENABLE ROW LEVEL SECURITY;

--
-- Name: events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

--
-- Name: fee_invoices; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fee_invoices ENABLE ROW LEVEL SECURITY;

--
-- Name: fin_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fin_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: fin_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fin_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: invoices; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_logs p_audit_logs_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_audit_logs_delete ON public.audit_logs FOR DELETE USING ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- Name: audit_logs p_audit_logs_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_audit_logs_insert ON public.audit_logs FOR INSERT WITH CHECK (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR ((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = audit_logs.club_id) AND c.is_active))))));


--
-- Name: audit_logs p_audit_logs_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_audit_logs_select ON public.audit_logs FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: audit_logs p_audit_logs_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_audit_logs_update ON public.audit_logs FOR UPDATE USING ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)) WITH CHECK ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- Name: club_features p_club_features_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_features_delete ON public.club_features FOR DELETE USING ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- Name: club_features p_club_features_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_features_insert ON public.club_features FOR INSERT WITH CHECK ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- Name: club_features p_club_features_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_features_select ON public.club_features FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: club_features p_club_features_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_features_update ON public.club_features FOR UPDATE USING ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)) WITH CHECK ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- Name: club_officials p_club_officials_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_officials_delete ON public.club_officials FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = club_officials.club_id) AND c.is_active)))));


--
-- Name: club_officials p_club_officials_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_officials_insert ON public.club_officials FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = club_officials.club_id) AND c.is_active)))));


--
-- Name: club_officials p_club_officials_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_officials_select ON public.club_officials FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: club_officials p_club_officials_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_club_officials_update ON public.club_officials FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = club_officials.club_id) AND c.is_active)))));


--
-- Name: documents p_documents_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_documents_delete ON public.documents FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = documents.club_id) AND c.is_active)))));


--
-- Name: documents p_documents_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_documents_insert ON public.documents FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = documents.club_id) AND c.is_active)))));


--
-- Name: documents p_documents_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_documents_select ON public.documents FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: documents p_documents_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_documents_update ON public.documents FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = documents.club_id) AND c.is_active)))));


--
-- Name: event_lineup_items p_event_lineup_items_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineup_items_delete ON public.event_lineup_items FOR DELETE USING (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (EXISTS ( SELECT 1
   FROM public.event_lineups l
  WHERE ((l.id = event_lineup_items.lineup_id) AND (l.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint)))))));


--
-- Name: event_lineup_items p_event_lineup_items_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineup_items_insert ON public.event_lineup_items FOR INSERT WITH CHECK (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (EXISTS ( SELECT 1
   FROM public.event_lineups l
  WHERE ((l.id = event_lineup_items.lineup_id) AND (l.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint)))))));


--
-- Name: event_lineup_items p_event_lineup_items_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineup_items_select ON public.event_lineup_items FOR SELECT USING (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (EXISTS ( SELECT 1
   FROM public.event_lineups l
  WHERE ((l.id = event_lineup_items.lineup_id) AND (l.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint)))))));


--
-- Name: event_lineup_items p_event_lineup_items_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineup_items_update ON public.event_lineup_items FOR UPDATE USING (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (EXISTS ( SELECT 1
   FROM public.event_lineups l
  WHERE ((l.id = event_lineup_items.lineup_id) AND (l.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint))))))) WITH CHECK (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (EXISTS ( SELECT 1
   FROM public.event_lineups l
  WHERE ((l.id = event_lineup_items.lineup_id) AND (l.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint)))))));


--
-- Name: event_lineups p_event_lineups_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineups_delete ON public.event_lineups FOR DELETE USING ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- Name: event_lineups p_event_lineups_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineups_insert ON public.event_lineups FOR INSERT WITH CHECK (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR ((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = event_lineups.club_id) AND c.is_active))))));


--
-- Name: event_lineups p_event_lineups_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineups_select ON public.event_lineups FOR SELECT USING (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint))));


--
-- Name: event_lineups p_event_lineups_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_event_lineups_update ON public.event_lineups FOR UPDATE USING (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint)))) WITH CHECK (((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text) OR (club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint, ('-1'::integer)::bigint))));


--
-- Name: events p_events_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_events_delete ON public.events FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = events.club_id) AND c.is_active)))));


--
-- Name: events p_events_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_events_insert ON public.events FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = events.club_id) AND c.is_active)))));


--
-- Name: events p_events_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_events_select ON public.events FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: events p_events_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_events_update ON public.events FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = events.club_id) AND c.is_active)))));


--
-- Name: fee_invoices p_fee_invoices_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fee_invoices_delete ON public.fee_invoices FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fee_invoices.club_id) AND c.is_active)))));


--
-- Name: fee_invoices p_fee_invoices_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fee_invoices_insert ON public.fee_invoices FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fee_invoices.club_id) AND c.is_active)))));


--
-- Name: fee_invoices p_fee_invoices_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fee_invoices_select ON public.fee_invoices FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: fee_invoices p_fee_invoices_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fee_invoices_update ON public.fee_invoices FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fee_invoices.club_id) AND c.is_active)))));


--
-- Name: fin_categories p_fin_categories_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_categories_delete ON public.fin_categories FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fin_categories.club_id) AND c.is_active)))));


--
-- Name: fin_categories p_fin_categories_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_categories_insert ON public.fin_categories FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fin_categories.club_id) AND c.is_active)))));


--
-- Name: fin_categories p_fin_categories_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_categories_select ON public.fin_categories FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: fin_categories p_fin_categories_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_categories_update ON public.fin_categories FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fin_categories.club_id) AND c.is_active)))));


--
-- Name: fin_transactions p_fin_transactions_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_transactions_delete ON public.fin_transactions FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fin_transactions.club_id) AND c.is_active)))));


--
-- Name: fin_transactions p_fin_transactions_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_transactions_insert ON public.fin_transactions FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fin_transactions.club_id) AND c.is_active)))));


--
-- Name: fin_transactions p_fin_transactions_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_transactions_select ON public.fin_transactions FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: fin_transactions p_fin_transactions_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_fin_transactions_update ON public.fin_transactions FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = fin_transactions.club_id) AND c.is_active)))));


--
-- Name: invoices p_invoices_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_invoices_delete ON public.invoices FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = invoices.club_id) AND c.is_active)))));


--
-- Name: invoices p_invoices_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_invoices_insert ON public.invoices FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = invoices.club_id) AND c.is_active)))));


--
-- Name: invoices p_invoices_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_invoices_select ON public.invoices FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: invoices p_invoices_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_invoices_update ON public.invoices FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = invoices.club_id) AND c.is_active)))));


--
-- Name: payments p_payments_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_payments_delete ON public.payments FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.invoices i
     JOIN public.clubs c ON ((c.id = i.club_id)))
  WHERE ((i.id = payments.invoice_id) AND (i.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND c.is_active))));


--
-- Name: payments p_payments_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_payments_insert ON public.payments FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.invoices i
     JOIN public.clubs c ON ((c.id = i.club_id)))
  WHERE ((i.id = payments.invoice_id) AND (i.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND c.is_active))));


--
-- Name: payments p_payments_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_payments_select ON public.payments FOR SELECT USING (((EXISTS ( SELECT 1
   FROM public.invoices i
  WHERE ((i.id = payments.invoice_id) AND (i.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer))))) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: payments p_payments_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_payments_update ON public.payments FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.invoices i
     JOIN public.clubs c ON ((c.id = i.club_id)))
  WHERE ((i.id = payments.invoice_id) AND (i.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND c.is_active)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.invoices i
     JOIN public.clubs c ON ((c.id = i.club_id)))
  WHERE ((i.id = payments.invoice_id) AND (i.club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND c.is_active))));


--
-- Name: player_medicals p_player_medicals_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_medicals_delete ON public.player_medicals FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = player_medicals.club_id) AND c.is_active)))));


--
-- Name: player_medicals p_player_medicals_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_medicals_insert ON public.player_medicals FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = player_medicals.club_id) AND c.is_active)))));


--
-- Name: player_medicals p_player_medicals_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_medicals_select ON public.player_medicals FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: player_medicals p_player_medicals_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_medicals_update ON public.player_medicals FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = player_medicals.club_id) AND c.is_active)))));


--
-- Name: player_registrations p_player_registrations_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_registrations_delete ON public.player_registrations FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = player_registrations.club_id) AND c.is_active)))));


--
-- Name: player_registrations p_player_registrations_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_registrations_insert ON public.player_registrations FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = player_registrations.club_id) AND c.is_active)))));


--
-- Name: player_registrations p_player_registrations_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_registrations_select ON public.player_registrations FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: player_registrations p_player_registrations_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_player_registrations_update ON public.player_registrations FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = player_registrations.club_id) AND c.is_active)))));


--
-- Name: players p_players_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_players_delete ON public.players FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = players.club_id) AND c.is_active)))));


--
-- Name: players p_players_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_players_insert ON public.players FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = players.club_id) AND c.is_active)))));


--
-- Name: players p_players_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_players_select ON public.players FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: players p_players_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_players_update ON public.players FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = players.club_id) AND c.is_active)))));


--
-- Name: registration_packages p_registration_packages_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_registration_packages_delete ON public.registration_packages FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = registration_packages.club_id) AND c.is_active)))));


--
-- Name: registration_packages p_registration_packages_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_registration_packages_insert ON public.registration_packages FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = registration_packages.club_id) AND c.is_active)))));


--
-- Name: registration_packages p_registration_packages_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_registration_packages_select ON public.registration_packages FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: registration_packages p_registration_packages_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_registration_packages_update ON public.registration_packages FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = registration_packages.club_id) AND c.is_active)))));


--
-- Name: settings p_settings_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_settings_delete ON public.settings FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = settings.club_id) AND c.is_active)))));


--
-- Name: settings p_settings_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_settings_insert ON public.settings FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = settings.club_id) AND c.is_active)))));


--
-- Name: settings p_settings_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_settings_select ON public.settings FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: settings p_settings_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_settings_update ON public.settings FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = settings.club_id) AND c.is_active)))));


--
-- Name: staff p_staff_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_staff_delete ON public.staff FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = staff.club_id) AND c.is_active)))));


--
-- Name: staff p_staff_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_staff_insert ON public.staff FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = staff.club_id) AND c.is_active)))));


--
-- Name: staff p_staff_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_staff_select ON public.staff FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: staff p_staff_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_staff_update ON public.staff FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = staff.club_id) AND c.is_active)))));


--
-- Name: subscriptions p_subscriptions_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_subscriptions_delete ON public.subscriptions FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = subscriptions.club_id) AND c.is_active)))));


--
-- Name: subscriptions p_subscriptions_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_subscriptions_insert ON public.subscriptions FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = subscriptions.club_id) AND c.is_active)))));


--
-- Name: subscriptions p_subscriptions_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_subscriptions_select ON public.subscriptions FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: subscriptions p_subscriptions_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_subscriptions_update ON public.subscriptions FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = subscriptions.club_id) AND c.is_active)))));


--
-- Name: teams p_teams_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_teams_delete ON public.teams FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = teams.club_id) AND c.is_active)))));


--
-- Name: teams p_teams_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_teams_insert ON public.teams FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = teams.club_id) AND c.is_active)))));


--
-- Name: teams p_teams_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_teams_select ON public.teams FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: teams p_teams_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_teams_update ON public.teams FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = teams.club_id) AND c.is_active)))));


--
-- Name: users p_users_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_users_delete ON public.users FOR DELETE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = users.club_id) AND c.is_active)))));


--
-- Name: users p_users_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_users_insert ON public.users FOR INSERT WITH CHECK (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = users.club_id) AND c.is_active)))));


--
-- Name: users p_users_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_users_select ON public.users FOR SELECT USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) OR (COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)));


--
-- Name: users p_users_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY p_users_update ON public.users FOR UPDATE USING (((club_id = COALESCE((NULLIF(current_setting('app.club_id'::text, true), ''::text))::integer, '-1'::integer)) AND (EXISTS ( SELECT 1
   FROM public.clubs c
  WHERE ((c.id = users.club_id) AND c.is_active)))));


--
-- Name: password_resets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.password_resets ENABLE ROW LEVEL SECURITY;

--
-- Name: password_resets password_resets_admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY password_resets_admin_all ON public.password_resets USING ((COALESCE(current_setting('app.is_admin'::text, true), '0'::text) = '1'::text)) WITH CHECK ((COALESCE(current_setting('app.is_admin'::text, true), '0'::text) = '1'::text));


--
-- Name: password_resets password_resets_tenant_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY password_resets_tenant_insert ON public.password_resets FOR INSERT WITH CHECK (((COALESCE(current_setting('app.is_admin'::text, true), '0'::text) = '1'::text) OR (EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = password_resets.user_id) AND (u.club_id = (NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint))))));


--
-- Name: password_resets password_resets_tenant_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY password_resets_tenant_read ON public.password_resets FOR SELECT USING (((COALESCE(current_setting('app.is_admin'::text, true), '0'::text) = '1'::text) OR (EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = password_resets.user_id) AND (u.club_id = (NULLIF(current_setting('app.club_id'::text, true), ''::text))::bigint))))));


--
-- Name: payments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

--
-- Name: payments payments_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY payments_policy ON public.payments USING (((COALESCE(current_setting('app.is_admin'::text, true), '0'::text) = '1'::text) OR (club_id = (COALESCE(NULLIF(current_setting('app.club_id'::text, true), ''::text), '0'::text))::bigint))) WITH CHECK (((COALESCE(current_setting('app.is_admin'::text, true), '0'::text) = '1'::text) OR (club_id = (COALESCE(NULLIF(current_setting('app.club_id'::text, true), ''::text), '0'::text))::bigint)));


--
-- Name: player_medicals; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.player_medicals ENABLE ROW LEVEL SECURITY;

--
-- Name: player_registrations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.player_registrations ENABLE ROW LEVEL SECURITY;

--
-- Name: players; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;

--
-- Name: registration_packages; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.registration_packages ENABLE ROW LEVEL SECURITY;

--
-- Name: settings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

--
-- Name: staff; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.staff ENABLE ROW LEVEL SECURITY;

--
-- Name: subscriptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: team_staff_memberships; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.team_staff_memberships ENABLE ROW LEVEL SECURITY;

--
-- Name: teams; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;

--
-- Name: team_staff_memberships tsm_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tsm_delete ON public.team_staff_memberships FOR DELETE USING ((club_id = (current_setting('app.club_id'::text, true))::bigint));


--
-- Name: team_staff_memberships tsm_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tsm_insert ON public.team_staff_memberships FOR INSERT WITH CHECK ((club_id = (current_setting('app.club_id'::text, true))::bigint));


--
-- Name: team_staff_memberships tsm_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tsm_select ON public.team_staff_memberships FOR SELECT USING ((club_id = (current_setting('app.club_id'::text, true))::bigint));


--
-- Name: team_staff_memberships tsm_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tsm_update ON public.team_staff_memberships FOR UPDATE USING ((club_id = (current_setting('app.club_id'::text, true))::bigint)) WITH CHECK ((club_id = (current_setting('app.club_id'::text, true))::bigint));


--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users users_admin_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY users_admin_insert ON public.users FOR INSERT WITH CHECK ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- Name: users users_admin_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY users_admin_update ON public.users FOR UPDATE USING ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text)) WITH CHECK ((COALESCE(current_setting('app.is_admin'::text, true), ''::text) = '1'::text));


--
-- PostgreSQL database dump complete
--

\unrestrict VNfeEFLJoo9hTdmEd5Ru7ELbgNbqNVUCzjSmzkdDhngzODU85VHUbsJFNbCsDoz

