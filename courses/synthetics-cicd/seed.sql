--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access (
    id bigint NOT NULL,
    user_id bigint,
    repo_id bigint,
    mode integer
);


ALTER TABLE public.access OWNER TO postgres;

--
-- Name: access_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_id_seq OWNER TO postgres;

--
-- Name: access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_id_seq OWNED BY public.access.id;


--
-- Name: access_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_token (
    id bigint NOT NULL,
    uid bigint,
    name text,
    sha1 character varying(40),
    created_unix bigint,
    updated_unix bigint
);


ALTER TABLE public.access_token OWNER TO postgres;

--
-- Name: access_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_token_id_seq OWNER TO postgres;

--
-- Name: access_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_token_id_seq OWNED BY public.access_token.id;


--
-- Name: action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action (
    id bigint NOT NULL,
    user_id bigint,
    op_type integer,
    act_user_id bigint,
    act_user_name character varying(255),
    repo_id bigint,
    repo_user_name character varying(255),
    repo_name character varying(255),
    ref_name character varying(255),
    is_private boolean DEFAULT false NOT NULL,
    content text,
    created_unix bigint
);


ALTER TABLE public.action OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_id_seq OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_id_seq OWNED BY public.action.id;


--
-- Name: attachment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attachment (
    id bigint NOT NULL,
    uuid uuid,
    issue_id bigint,
    comment_id bigint,
    release_id bigint,
    name character varying(255),
    created_unix bigint
);


ALTER TABLE public.attachment OWNER TO postgres;

--
-- Name: attachment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attachment_id_seq OWNER TO postgres;

--
-- Name: attachment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attachment_id_seq OWNED BY public.attachment.id;


--
-- Name: collaboration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collaboration (
    id bigint NOT NULL,
    repo_id bigint NOT NULL,
    user_id bigint NOT NULL,
    mode integer DEFAULT 2 NOT NULL
);


ALTER TABLE public.collaboration OWNER TO postgres;

--
-- Name: collaboration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collaboration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collaboration_id_seq OWNER TO postgres;

--
-- Name: collaboration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collaboration_id_seq OWNED BY public.collaboration.id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    id bigint NOT NULL,
    type integer,
    poster_id bigint,
    issue_id bigint,
    commit_id bigint,
    line bigint,
    content text,
    created_unix bigint,
    updated_unix bigint,
    commit_sha character varying(40)
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_id_seq OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_id_seq OWNED BY public.comment.id;


--
-- Name: deploy_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deploy_key (
    id bigint NOT NULL,
    key_id bigint,
    repo_id bigint,
    name character varying(255),
    fingerprint character varying(255),
    created_unix bigint,
    updated_unix bigint
);


ALTER TABLE public.deploy_key OWNER TO postgres;

--
-- Name: deploy_key_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deploy_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deploy_key_id_seq OWNER TO postgres;

--
-- Name: deploy_key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deploy_key_id_seq OWNED BY public.deploy_key.id;


--
-- Name: email_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_address (
    id bigint NOT NULL,
    uid bigint NOT NULL,
    email character varying(255) NOT NULL,
    is_activated boolean
);


ALTER TABLE public.email_address OWNER TO postgres;

--
-- Name: email_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_address_id_seq OWNER TO postgres;

--
-- Name: email_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_address_id_seq OWNED BY public.email_address.id;


--
-- Name: follow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follow (
    id bigint NOT NULL,
    user_id bigint,
    follow_id bigint
);


ALTER TABLE public.follow OWNER TO postgres;

--
-- Name: follow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.follow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.follow_id_seq OWNER TO postgres;

--
-- Name: follow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.follow_id_seq OWNED BY public.follow.id;


--
-- Name: hook_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hook_task (
    id bigint NOT NULL,
    repo_id bigint,
    hook_id bigint,
    uuid character varying(255),
    type integer,
    url text,
    signature text,
    payload_content text,
    content_type integer,
    event_type character varying(255),
    is_ssl boolean,
    is_delivered boolean,
    delivered bigint,
    is_succeed boolean,
    request_content text,
    response_content text
);


ALTER TABLE public.hook_task OWNER TO postgres;

--
-- Name: hook_task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hook_task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hook_task_id_seq OWNER TO postgres;

--
-- Name: hook_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hook_task_id_seq OWNED BY public.hook_task.id;


--
-- Name: issue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issue (
    id bigint NOT NULL,
    repo_id bigint,
    index bigint,
    poster_id bigint,
    name character varying(255),
    content text,
    milestone_id bigint,
    priority integer,
    assignee_id bigint,
    is_closed boolean,
    is_pull boolean,
    num_comments integer,
    deadline_unix bigint,
    created_unix bigint,
    updated_unix bigint
);


ALTER TABLE public.issue OWNER TO postgres;

--
-- Name: issue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issue_id_seq OWNER TO postgres;

--
-- Name: issue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issue_id_seq OWNED BY public.issue.id;


--
-- Name: issue_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issue_label (
    id bigint NOT NULL,
    issue_id bigint,
    label_id bigint
);


ALTER TABLE public.issue_label OWNER TO postgres;

--
-- Name: issue_label_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issue_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issue_label_id_seq OWNER TO postgres;

--
-- Name: issue_label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issue_label_id_seq OWNED BY public.issue_label.id;


--
-- Name: issue_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issue_user (
    id bigint NOT NULL,
    uid bigint,
    issue_id bigint,
    repo_id bigint,
    milestone_id bigint,
    is_read boolean,
    is_assigned boolean,
    is_mentioned boolean,
    is_poster boolean,
    is_closed boolean
);


ALTER TABLE public.issue_user OWNER TO postgres;

--
-- Name: issue_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issue_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issue_user_id_seq OWNER TO postgres;

--
-- Name: issue_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issue_user_id_seq OWNED BY public.issue_user.id;


--
-- Name: label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.label (
    id bigint NOT NULL,
    repo_id bigint,
    name character varying(255),
    color character varying(7),
    num_issues integer,
    num_closed_issues integer
);


ALTER TABLE public.label OWNER TO postgres;

--
-- Name: label_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.label_id_seq OWNER TO postgres;

--
-- Name: label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.label_id_seq OWNED BY public.label.id;


--
-- Name: lfs_object; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lfs_object (
    repo_id bigint NOT NULL,
    oid text NOT NULL,
    size bigint NOT NULL,
    storage text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.lfs_object OWNER TO postgres;

--
-- Name: login_source; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_source (
    id bigint NOT NULL,
    type integer,
    name text,
    is_actived boolean NOT NULL,
    is_default boolean,
    cfg text,
    created_unix bigint,
    updated_unix bigint
);


ALTER TABLE public.login_source OWNER TO postgres;

--
-- Name: login_source_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.login_source_id_seq OWNER TO postgres;

--
-- Name: login_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_source_id_seq OWNED BY public.login_source.id;


--
-- Name: milestone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.milestone (
    id bigint NOT NULL,
    repo_id bigint,
    name character varying(255),
    content text,
    is_closed boolean,
    num_issues integer,
    num_closed_issues integer,
    completeness integer,
    deadline_unix bigint,
    closed_date_unix bigint
);


ALTER TABLE public.milestone OWNER TO postgres;

--
-- Name: milestone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.milestone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.milestone_id_seq OWNER TO postgres;

--
-- Name: milestone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.milestone_id_seq OWNED BY public.milestone.id;


--
-- Name: mirror; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mirror (
    id bigint NOT NULL,
    repo_id bigint,
    "interval" integer,
    enable_prune boolean DEFAULT true NOT NULL,
    updated_unix bigint,
    next_update_unix bigint
);


ALTER TABLE public.mirror OWNER TO postgres;

--
-- Name: mirror_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mirror_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mirror_id_seq OWNER TO postgres;

--
-- Name: mirror_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mirror_id_seq OWNED BY public.mirror.id;


--
-- Name: notice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notice (
    id bigint NOT NULL,
    type integer,
    description text,
    created_unix bigint
);


ALTER TABLE public.notice OWNER TO postgres;

--
-- Name: notice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notice_id_seq OWNER TO postgres;

--
-- Name: notice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notice_id_seq OWNED BY public.notice.id;


--
-- Name: org_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_user (
    id bigint NOT NULL,
    uid bigint,
    org_id bigint,
    is_public boolean,
    is_owner boolean,
    num_teams integer
);


ALTER TABLE public.org_user OWNER TO postgres;

--
-- Name: org_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.org_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.org_user_id_seq OWNER TO postgres;

--
-- Name: org_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.org_user_id_seq OWNED BY public.org_user.id;


--
-- Name: protect_branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protect_branch (
    id bigint NOT NULL,
    repo_id bigint,
    name character varying(255),
    protected boolean,
    require_pull_request boolean,
    enable_whitelist boolean,
    whitelist_user_i_ds text,
    whitelist_team_i_ds text
);


ALTER TABLE public.protect_branch OWNER TO postgres;

--
-- Name: protect_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.protect_branch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.protect_branch_id_seq OWNER TO postgres;

--
-- Name: protect_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.protect_branch_id_seq OWNED BY public.protect_branch.id;


--
-- Name: protect_branch_whitelist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protect_branch_whitelist (
    id bigint NOT NULL,
    protect_branch_id bigint,
    repo_id bigint,
    name character varying(255),
    user_id bigint
);


ALTER TABLE public.protect_branch_whitelist OWNER TO postgres;

--
-- Name: protect_branch_whitelist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.protect_branch_whitelist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.protect_branch_whitelist_id_seq OWNER TO postgres;

--
-- Name: protect_branch_whitelist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.protect_branch_whitelist_id_seq OWNED BY public.protect_branch_whitelist.id;


--
-- Name: public_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_key (
    id bigint NOT NULL,
    owner_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    fingerprint character varying(255) NOT NULL,
    content text NOT NULL,
    mode integer DEFAULT 2 NOT NULL,
    type integer DEFAULT 1 NOT NULL,
    created_unix bigint,
    updated_unix bigint
);


ALTER TABLE public.public_key OWNER TO postgres;

--
-- Name: public_key_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_key_id_seq OWNER TO postgres;

--
-- Name: public_key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_key_id_seq OWNED BY public.public_key.id;


--
-- Name: pull_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pull_request (
    id bigint NOT NULL,
    type integer,
    status integer,
    issue_id bigint,
    index bigint,
    head_repo_id bigint,
    base_repo_id bigint,
    head_user_name character varying(255),
    head_branch character varying(255),
    base_branch character varying(255),
    merge_base character varying(40),
    has_merged boolean,
    merged_commit_id character varying(40),
    merger_id bigint,
    merged_unix bigint
);


ALTER TABLE public.pull_request OWNER TO postgres;

--
-- Name: pull_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pull_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pull_request_id_seq OWNER TO postgres;

--
-- Name: pull_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pull_request_id_seq OWNED BY public.pull_request.id;


--
-- Name: release; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.release (
    id bigint NOT NULL,
    repo_id bigint,
    publisher_id bigint,
    tag_name character varying(255),
    lower_tag_name character varying(255),
    target character varying(255),
    title character varying(255),
    sha1 character varying(40),
    num_commits bigint,
    note text,
    is_draft boolean DEFAULT false NOT NULL,
    is_prerelease boolean,
    created_unix bigint
);


ALTER TABLE public.release OWNER TO postgres;

--
-- Name: release_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.release_id_seq OWNER TO postgres;

--
-- Name: release_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.release_id_seq OWNED BY public.release.id;


--
-- Name: repository; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repository (
    id bigint NOT NULL,
    owner_id bigint,
    lower_name character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(512),
    website character varying(255),
    default_branch character varying(255),
    size bigint DEFAULT 0 NOT NULL,
    use_custom_avatar boolean,
    num_watches integer,
    num_stars integer,
    num_forks integer,
    num_issues integer,
    num_closed_issues integer,
    num_pulls integer,
    num_closed_pulls integer,
    num_milestones integer DEFAULT 0 NOT NULL,
    num_closed_milestones integer DEFAULT 0 NOT NULL,
    is_private boolean,
    is_bare boolean,
    is_mirror boolean,
    enable_wiki boolean DEFAULT true NOT NULL,
    allow_public_wiki boolean,
    enable_external_wiki boolean,
    external_wiki_url character varying(255),
    enable_issues boolean DEFAULT true NOT NULL,
    allow_public_issues boolean,
    enable_external_tracker boolean,
    external_tracker_url character varying(255),
    external_tracker_format character varying(255),
    external_tracker_style character varying(255),
    enable_pulls boolean DEFAULT true NOT NULL,
    pulls_ignore_whitespace boolean DEFAULT false NOT NULL,
    pulls_allow_rebase boolean DEFAULT false NOT NULL,
    is_fork boolean DEFAULT false NOT NULL,
    fork_id bigint,
    created_unix bigint,
    updated_unix bigint
);


ALTER TABLE public.repository OWNER TO postgres;

--
-- Name: repository_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repository_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repository_id_seq OWNER TO postgres;

--
-- Name: repository_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repository_id_seq OWNED BY public.repository.id;


--
-- Name: star; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.star (
    id bigint NOT NULL,
    uid bigint,
    repo_id bigint
);


ALTER TABLE public.star OWNER TO postgres;

--
-- Name: star_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.star_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.star_id_seq OWNER TO postgres;

--
-- Name: star_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.star_id_seq OWNED BY public.star.id;


--
-- Name: team; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team (
    id bigint NOT NULL,
    org_id bigint,
    lower_name character varying(255),
    name character varying(255),
    description character varying(255),
    authorize integer,
    num_repos integer,
    num_members integer
);


ALTER TABLE public.team OWNER TO postgres;

--
-- Name: team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_id_seq OWNER TO postgres;

--
-- Name: team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_id_seq OWNED BY public.team.id;


--
-- Name: team_repo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_repo (
    id bigint NOT NULL,
    org_id bigint,
    team_id bigint,
    repo_id bigint
);


ALTER TABLE public.team_repo OWNER TO postgres;

--
-- Name: team_repo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_repo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_repo_id_seq OWNER TO postgres;

--
-- Name: team_repo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_repo_id_seq OWNED BY public.team_repo.id;


--
-- Name: team_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_user (
    id bigint NOT NULL,
    org_id bigint,
    team_id bigint,
    uid bigint
);


ALTER TABLE public.team_user OWNER TO postgres;

--
-- Name: team_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_user_id_seq OWNER TO postgres;

--
-- Name: team_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_user_id_seq OWNED BY public.team_user.id;


--
-- Name: two_factor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.two_factor (
    id bigint NOT NULL,
    user_id bigint,
    secret character varying(255),
    created_unix bigint
);


ALTER TABLE public.two_factor OWNER TO postgres;

--
-- Name: two_factor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.two_factor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.two_factor_id_seq OWNER TO postgres;

--
-- Name: two_factor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.two_factor_id_seq OWNED BY public.two_factor.id;


--
-- Name: two_factor_recovery_code; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.two_factor_recovery_code (
    id bigint NOT NULL,
    user_id bigint,
    code character varying(11),
    is_used boolean
);


ALTER TABLE public.two_factor_recovery_code OWNER TO postgres;

--
-- Name: two_factor_recovery_code_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.two_factor_recovery_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.two_factor_recovery_code_id_seq OWNER TO postgres;

--
-- Name: two_factor_recovery_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.two_factor_recovery_code_id_seq OWNED BY public.two_factor_recovery_code.id;


--
-- Name: upload; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.upload (
    id bigint NOT NULL,
    uuid uuid,
    name character varying(255)
);


ALTER TABLE public.upload OWNER TO postgres;

--
-- Name: upload_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.upload_id_seq OWNER TO postgres;

--
-- Name: upload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.upload_id_seq OWNED BY public.upload.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id bigint NOT NULL,
    lower_name character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    full_name character varying(255),
    email character varying(255) NOT NULL,
    passwd character varying(255) NOT NULL,
    login_source bigint DEFAULT 0 NOT NULL,
    login_name character varying(255),
    type integer,
    location character varying(255),
    website character varying(255),
    rands character varying(10),
    salt character varying(10),
    created_unix bigint,
    updated_unix bigint,
    last_repo_visibility boolean,
    max_repo_creation integer DEFAULT '-1'::integer NOT NULL,
    is_active boolean,
    is_admin boolean,
    allow_git_hook boolean,
    allow_import_local boolean,
    prohibit_login boolean,
    avatar character varying(2048) NOT NULL,
    avatar_email character varying(255) NOT NULL,
    use_custom_avatar boolean,
    num_followers integer,
    num_following integer DEFAULT 0 NOT NULL,
    num_stars integer,
    num_repos integer,
    description character varying(255),
    num_teams integer,
    num_members integer
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.version (
    id bigint NOT NULL,
    version bigint
);


ALTER TABLE public.version OWNER TO postgres;

--
-- Name: version_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.version_id_seq OWNER TO postgres;

--
-- Name: version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.version_id_seq OWNED BY public.version.id;


--
-- Name: watch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.watch (
    id bigint NOT NULL,
    user_id bigint,
    repo_id bigint
);


ALTER TABLE public.watch OWNER TO postgres;

--
-- Name: watch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.watch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.watch_id_seq OWNER TO postgres;

--
-- Name: watch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.watch_id_seq OWNED BY public.watch.id;


--
-- Name: webhook; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.webhook (
    id bigint NOT NULL,
    repo_id bigint,
    org_id bigint,
    url text,
    content_type integer,
    secret text,
    events text,
    is_ssl boolean,
    is_active boolean,
    hook_task_type integer,
    meta text,
    last_status integer,
    created_unix bigint,
    updated_unix bigint
);


ALTER TABLE public.webhook OWNER TO postgres;

--
-- Name: webhook_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.webhook_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webhook_id_seq OWNER TO postgres;

--
-- Name: webhook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.webhook_id_seq OWNED BY public.webhook.id;


--
-- Name: access id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access ALTER COLUMN id SET DEFAULT nextval('public.access_id_seq'::regclass);


--
-- Name: access_token id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token ALTER COLUMN id SET DEFAULT nextval('public.access_token_id_seq'::regclass);


--
-- Name: action id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action ALTER COLUMN id SET DEFAULT nextval('public.action_id_seq'::regclass);


--
-- Name: attachment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attachment ALTER COLUMN id SET DEFAULT nextval('public.attachment_id_seq'::regclass);


--
-- Name: collaboration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaboration ALTER COLUMN id SET DEFAULT nextval('public.collaboration_id_seq'::regclass);


--
-- Name: comment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment ALTER COLUMN id SET DEFAULT nextval('public.comment_id_seq'::regclass);


--
-- Name: deploy_key id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deploy_key ALTER COLUMN id SET DEFAULT nextval('public.deploy_key_id_seq'::regclass);


--
-- Name: email_address id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_address ALTER COLUMN id SET DEFAULT nextval('public.email_address_id_seq'::regclass);


--
-- Name: follow id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow ALTER COLUMN id SET DEFAULT nextval('public.follow_id_seq'::regclass);


--
-- Name: hook_task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hook_task ALTER COLUMN id SET DEFAULT nextval('public.hook_task_id_seq'::regclass);


--
-- Name: issue id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue ALTER COLUMN id SET DEFAULT nextval('public.issue_id_seq'::regclass);


--
-- Name: issue_label id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_label ALTER COLUMN id SET DEFAULT nextval('public.issue_label_id_seq'::regclass);


--
-- Name: issue_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_user ALTER COLUMN id SET DEFAULT nextval('public.issue_user_id_seq'::regclass);


--
-- Name: label id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label ALTER COLUMN id SET DEFAULT nextval('public.label_id_seq'::regclass);


--
-- Name: login_source id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_source ALTER COLUMN id SET DEFAULT nextval('public.login_source_id_seq'::regclass);


--
-- Name: milestone id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestone ALTER COLUMN id SET DEFAULT nextval('public.milestone_id_seq'::regclass);


--
-- Name: mirror id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mirror ALTER COLUMN id SET DEFAULT nextval('public.mirror_id_seq'::regclass);


--
-- Name: notice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notice ALTER COLUMN id SET DEFAULT nextval('public.notice_id_seq'::regclass);


--
-- Name: org_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_user ALTER COLUMN id SET DEFAULT nextval('public.org_user_id_seq'::regclass);


--
-- Name: protect_branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protect_branch ALTER COLUMN id SET DEFAULT nextval('public.protect_branch_id_seq'::regclass);


--
-- Name: protect_branch_whitelist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protect_branch_whitelist ALTER COLUMN id SET DEFAULT nextval('public.protect_branch_whitelist_id_seq'::regclass);


--
-- Name: public_key id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_key ALTER COLUMN id SET DEFAULT nextval('public.public_key_id_seq'::regclass);


--
-- Name: pull_request id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request ALTER COLUMN id SET DEFAULT nextval('public.pull_request_id_seq'::regclass);


--
-- Name: release id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.release ALTER COLUMN id SET DEFAULT nextval('public.release_id_seq'::regclass);


--
-- Name: repository id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repository ALTER COLUMN id SET DEFAULT nextval('public.repository_id_seq'::regclass);


--
-- Name: star id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.star ALTER COLUMN id SET DEFAULT nextval('public.star_id_seq'::regclass);


--
-- Name: team id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team ALTER COLUMN id SET DEFAULT nextval('public.team_id_seq'::regclass);


--
-- Name: team_repo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_repo ALTER COLUMN id SET DEFAULT nextval('public.team_repo_id_seq'::regclass);


--
-- Name: team_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_user ALTER COLUMN id SET DEFAULT nextval('public.team_user_id_seq'::regclass);


--
-- Name: two_factor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.two_factor ALTER COLUMN id SET DEFAULT nextval('public.two_factor_id_seq'::regclass);


--
-- Name: two_factor_recovery_code id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.two_factor_recovery_code ALTER COLUMN id SET DEFAULT nextval('public.two_factor_recovery_code_id_seq'::regclass);


--
-- Name: upload id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload ALTER COLUMN id SET DEFAULT nextval('public.upload_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: version id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.version ALTER COLUMN id SET DEFAULT nextval('public.version_id_seq'::regclass);


--
-- Name: watch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch ALTER COLUMN id SET DEFAULT nextval('public.watch_id_seq'::regclass);


--
-- Name: webhook id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.webhook ALTER COLUMN id SET DEFAULT nextval('public.webhook_id_seq'::regclass);


--
-- Data for Name: access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access (id, user_id, repo_id, mode) FROM stdin;
\.


--
-- Data for Name: access_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_token (id, uid, name, sha1, created_unix, updated_unix) FROM stdin;
\.


--
-- Data for Name: action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.action (id, user_id, op_type, act_user_id, act_user_name, repo_id, repo_user_name, repo_name, ref_name, is_private, content, created_unix) FROM stdin;
1	1	1	1	labuser	1	labuser	discounts-service		f		1648579444
2	1	16	1	labuser	1	labuser	discounts-service	main	f	{"Len":1,"Commits":[{"Sha1":"04faad62222aa613eb215aaec27bd789c7dcae1a","Message":"initial commit\\n","AuthorEmail":"labuser@example.com","AuthorName":"labuser","CommitterEmail":"labuser@example.com","CommitterName":"labuser","Timestamp":"2022-03-29T18:53:53Z"}],"CompareURL":""}	1648580038
3	1	5	1	labuser	1	labuser	discounts-service	main	f	{"Len":1,"Commits":[{"Sha1":"04faad62222aa613eb215aaec27bd789c7dcae1a","Message":"initial commit\\n","AuthorEmail":"labuser@example.com","AuthorName":"labuser","CommitterEmail":"labuser@example.com","CommitterName":"labuser","Timestamp":"2022-03-29T18:53:53Z"}],"CompareURL":""}	1648580038
\.


--
-- Data for Name: attachment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attachment (id, uuid, issue_id, comment_id, release_id, name, created_unix) FROM stdin;
\.


--
-- Data for Name: collaboration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collaboration (id, repo_id, user_id, mode) FROM stdin;
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment (id, type, poster_id, issue_id, commit_id, line, content, created_unix, updated_unix, commit_sha) FROM stdin;
\.


--
-- Data for Name: deploy_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deploy_key (id, key_id, repo_id, name, fingerprint, created_unix, updated_unix) FROM stdin;
\.


--
-- Data for Name: email_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_address (id, uid, email, is_activated) FROM stdin;
\.


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follow (id, user_id, follow_id) FROM stdin;
\.


--
-- Data for Name: hook_task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hook_task (id, repo_id, hook_id, uuid, type, url, signature, payload_content, content_type, event_type, is_ssl, is_delivered, delivered, is_succeed, request_content, response_content) FROM stdin;
\.


--
-- Data for Name: issue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issue (id, repo_id, index, poster_id, name, content, milestone_id, priority, assignee_id, is_closed, is_pull, num_comments, deadline_unix, created_unix, updated_unix) FROM stdin;
\.


--
-- Data for Name: issue_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issue_label (id, issue_id, label_id) FROM stdin;
\.


--
-- Data for Name: issue_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issue_user (id, uid, issue_id, repo_id, milestone_id, is_read, is_assigned, is_mentioned, is_poster, is_closed) FROM stdin;
\.


--
-- Data for Name: label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.label (id, repo_id, name, color, num_issues, num_closed_issues) FROM stdin;
\.


--
-- Data for Name: lfs_object; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lfs_object (repo_id, oid, size, storage, created_at) FROM stdin;
\.


--
-- Data for Name: login_source; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_source (id, type, name, is_actived, is_default, cfg, created_unix, updated_unix) FROM stdin;
\.


--
-- Data for Name: milestone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.milestone (id, repo_id, name, content, is_closed, num_issues, num_closed_issues, completeness, deadline_unix, closed_date_unix) FROM stdin;
\.


--
-- Data for Name: mirror; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mirror (id, repo_id, "interval", enable_prune, updated_unix, next_update_unix) FROM stdin;
\.


--
-- Data for Name: notice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notice (id, type, description, created_unix) FROM stdin;
\.


--
-- Data for Name: org_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_user (id, uid, org_id, is_public, is_owner, num_teams) FROM stdin;
\.


--
-- Data for Name: protect_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.protect_branch (id, repo_id, name, protected, require_pull_request, enable_whitelist, whitelist_user_i_ds, whitelist_team_i_ds) FROM stdin;
\.


--
-- Data for Name: protect_branch_whitelist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.protect_branch_whitelist (id, protect_branch_id, repo_id, name, user_id) FROM stdin;
\.


--
-- Data for Name: public_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_key (id, owner_id, name, fingerprint, content, mode, type, created_unix, updated_unix) FROM stdin;
\.


--
-- Data for Name: pull_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pull_request (id, type, status, issue_id, index, head_repo_id, base_repo_id, head_user_name, head_branch, base_branch, merge_base, has_merged, merged_commit_id, merger_id, merged_unix) FROM stdin;
\.


--
-- Data for Name: release; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.release (id, repo_id, publisher_id, tag_name, lower_tag_name, target, title, sha1, num_commits, note, is_draft, is_prerelease, created_unix) FROM stdin;
\.


--
-- Data for Name: repository; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repository (id, owner_id, lower_name, name, description, website, default_branch, size, use_custom_avatar, num_watches, num_stars, num_forks, num_issues, num_closed_issues, num_pulls, num_closed_pulls, num_milestones, num_closed_milestones, is_private, is_bare, is_mirror, enable_wiki, allow_public_wiki, enable_external_wiki, external_wiki_url, enable_issues, allow_public_issues, enable_external_tracker, external_tracker_url, external_tracker_format, external_tracker_style, enable_pulls, pulls_ignore_whitespace, pulls_allow_rebase, is_fork, fork_id, created_unix, updated_unix) FROM stdin;
1	1	discounts-service	discounts-service			main	45056	f	1	0	0	0	0	0	0	0	0	f	f	f	t	f	f		t	f	f			numeric	t	f	f	f	0	1648579444	1648580071
\.


--
-- Data for Name: star; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.star (id, uid, repo_id) FROM stdin;
\.


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team (id, org_id, lower_name, name, description, authorize, num_repos, num_members) FROM stdin;
\.


--
-- Data for Name: team_repo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_repo (id, org_id, team_id, repo_id) FROM stdin;
\.


--
-- Data for Name: team_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_user (id, org_id, team_id, uid) FROM stdin;
\.


--
-- Data for Name: two_factor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.two_factor (id, user_id, secret, created_unix) FROM stdin;
\.


--
-- Data for Name: two_factor_recovery_code; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.two_factor_recovery_code (id, user_id, code, is_used) FROM stdin;
\.


--
-- Data for Name: upload; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.upload (id, uuid, name) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, lower_name, name, full_name, email, passwd, login_source, login_name, type, location, website, rands, salt, created_unix, updated_unix, last_repo_visibility, max_repo_creation, is_active, is_admin, allow_git_hook, allow_import_local, prohibit_login, avatar, avatar_email, use_custom_avatar, num_followers, num_following, num_stars, num_repos, description, num_teams, num_members) FROM stdin;
1	labuser	labuser		labuser@lab.local	538e71fc34a609395036ca7a81f2ade9898619ef1185208149a61f49705026225b115a557772ea0714f5350b376e622dd945	0		0			34u7FZtsZS	DnY1jCbj7l	1648579394	1648579444	f	-1	t	t	f	f	f	11fefee04e1027e1069c6c7fe9251c7e	labuser@lab.local	f	0	0	0	1		0	0
\.


--
-- Data for Name: version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.version (id, version) FROM stdin;
1	19
\.


--
-- Data for Name: watch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.watch (id, user_id, repo_id) FROM stdin;
1	1	1
\.


--
-- Data for Name: webhook; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.webhook (id, repo_id, org_id, url, content_type, secret, events, is_ssl, is_active, hook_task_type, meta, last_status, created_unix, updated_unix) FROM stdin;
\.


--
-- Name: access_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_id_seq', 1, false);


--
-- Name: access_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_token_id_seq', 1, false);


--
-- Name: action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.action_id_seq', 3, true);


--
-- Name: attachment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attachment_id_seq', 1, false);


--
-- Name: collaboration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collaboration_id_seq', 1, false);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_id_seq', 1, false);


--
-- Name: deploy_key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deploy_key_id_seq', 1, false);


--
-- Name: email_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_address_id_seq', 1, false);


--
-- Name: follow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.follow_id_seq', 1, false);


--
-- Name: hook_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hook_task_id_seq', 1, false);


--
-- Name: issue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issue_id_seq', 1, false);


--
-- Name: issue_label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issue_label_id_seq', 1, false);


--
-- Name: issue_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issue_user_id_seq', 1, false);


--
-- Name: label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.label_id_seq', 1, false);


--
-- Name: login_source_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_source_id_seq', 1, false);


--
-- Name: milestone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.milestone_id_seq', 1, false);


--
-- Name: mirror_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mirror_id_seq', 1, false);


--
-- Name: notice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notice_id_seq', 1, false);


--
-- Name: org_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.org_user_id_seq', 1, false);


--
-- Name: protect_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.protect_branch_id_seq', 1, false);


--
-- Name: protect_branch_whitelist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.protect_branch_whitelist_id_seq', 1, false);


--
-- Name: public_key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_key_id_seq', 1, false);


--
-- Name: pull_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pull_request_id_seq', 1, false);


--
-- Name: release_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.release_id_seq', 1, false);


--
-- Name: repository_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repository_id_seq', 1, true);


--
-- Name: star_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.star_id_seq', 1, false);


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_id_seq', 1, false);


--
-- Name: team_repo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_repo_id_seq', 1, false);


--
-- Name: team_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_user_id_seq', 1, false);


--
-- Name: two_factor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.two_factor_id_seq', 1, false);


--
-- Name: two_factor_recovery_code_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.two_factor_recovery_code_id_seq', 1, false);


--
-- Name: upload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.upload_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.version_id_seq', 1, true);


--
-- Name: watch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.watch_id_seq', 1, true);


--
-- Name: webhook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.webhook_id_seq', 1, false);


--
-- Name: access access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access
    ADD CONSTRAINT access_pkey PRIMARY KEY (id);


--
-- Name: access_token access_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token
    ADD CONSTRAINT access_token_pkey PRIMARY KEY (id);


--
-- Name: access_token access_token_sha1_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token
    ADD CONSTRAINT access_token_sha1_key UNIQUE (sha1);


--
-- Name: action action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_pkey PRIMARY KEY (id);


--
-- Name: attachment attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attachment
    ADD CONSTRAINT attachment_pkey PRIMARY KEY (id);


--
-- Name: collaboration collaboration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaboration
    ADD CONSTRAINT collaboration_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: deploy_key deploy_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deploy_key
    ADD CONSTRAINT deploy_key_pkey PRIMARY KEY (id);


--
-- Name: email_address email_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_address
    ADD CONSTRAINT email_address_pkey PRIMARY KEY (id);


--
-- Name: follow follow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT follow_pkey PRIMARY KEY (id);


--
-- Name: hook_task hook_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hook_task
    ADD CONSTRAINT hook_task_pkey PRIMARY KEY (id);


--
-- Name: issue_label issue_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_label
    ADD CONSTRAINT issue_label_pkey PRIMARY KEY (id);


--
-- Name: issue issue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue
    ADD CONSTRAINT issue_pkey PRIMARY KEY (id);


--
-- Name: issue_user issue_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_user
    ADD CONSTRAINT issue_user_pkey PRIMARY KEY (id);


--
-- Name: label label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_pkey PRIMARY KEY (id);


--
-- Name: lfs_object lfs_object_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lfs_object
    ADD CONSTRAINT lfs_object_pkey PRIMARY KEY (repo_id, oid);


--
-- Name: login_source login_source_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_source
    ADD CONSTRAINT login_source_name_key UNIQUE (name);


--
-- Name: login_source login_source_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_source
    ADD CONSTRAINT login_source_pkey PRIMARY KEY (id);


--
-- Name: milestone milestone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestone
    ADD CONSTRAINT milestone_pkey PRIMARY KEY (id);


--
-- Name: mirror mirror_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mirror
    ADD CONSTRAINT mirror_pkey PRIMARY KEY (id);


--
-- Name: notice notice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notice
    ADD CONSTRAINT notice_pkey PRIMARY KEY (id);


--
-- Name: org_user org_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_user
    ADD CONSTRAINT org_user_pkey PRIMARY KEY (id);


--
-- Name: protect_branch protect_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protect_branch
    ADD CONSTRAINT protect_branch_pkey PRIMARY KEY (id);


--
-- Name: protect_branch_whitelist protect_branch_whitelist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protect_branch_whitelist
    ADD CONSTRAINT protect_branch_whitelist_pkey PRIMARY KEY (id);


--
-- Name: public_key public_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_key
    ADD CONSTRAINT public_key_pkey PRIMARY KEY (id);


--
-- Name: pull_request pull_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request
    ADD CONSTRAINT pull_request_pkey PRIMARY KEY (id);


--
-- Name: release release_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.release
    ADD CONSTRAINT release_pkey PRIMARY KEY (id);


--
-- Name: repository repository_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT repository_pkey PRIMARY KEY (id);


--
-- Name: star star_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.star
    ADD CONSTRAINT star_pkey PRIMARY KEY (id);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: team_repo team_repo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_repo
    ADD CONSTRAINT team_repo_pkey PRIMARY KEY (id);


--
-- Name: team_user team_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_user
    ADD CONSTRAINT team_user_pkey PRIMARY KEY (id);


--
-- Name: two_factor two_factor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.two_factor
    ADD CONSTRAINT two_factor_pkey PRIMARY KEY (id);


--
-- Name: two_factor_recovery_code two_factor_recovery_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.two_factor_recovery_code
    ADD CONSTRAINT two_factor_recovery_code_pkey PRIMARY KEY (id);


--
-- Name: upload upload_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: version version_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.version
    ADD CONSTRAINT version_pkey PRIMARY KEY (id);


--
-- Name: watch watch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch
    ADD CONSTRAINT watch_pkey PRIMARY KEY (id);


--
-- Name: webhook webhook_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.webhook
    ADD CONSTRAINT webhook_pkey PRIMARY KEY (id);


--
-- Name: IDX_action_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_action_repo_id" ON public.action USING btree (repo_id);


--
-- Name: IDX_attachment_issue_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_attachment_issue_id" ON public.attachment USING btree (issue_id);


--
-- Name: IDX_attachment_release_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_attachment_release_id" ON public.attachment USING btree (release_id);


--
-- Name: IDX_collaboration_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_collaboration_repo_id" ON public.collaboration USING btree (repo_id);


--
-- Name: IDX_collaboration_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_collaboration_user_id" ON public.collaboration USING btree (user_id);


--
-- Name: IDX_comment_issue_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_comment_issue_id" ON public.comment USING btree (issue_id);


--
-- Name: IDX_deploy_key_key_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deploy_key_key_id" ON public.deploy_key USING btree (key_id);


--
-- Name: IDX_deploy_key_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deploy_key_repo_id" ON public.deploy_key USING btree (repo_id);


--
-- Name: IDX_email_address_uid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_email_address_uid" ON public.email_address USING btree (uid);


--
-- Name: IDX_hook_task_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_hook_task_repo_id" ON public.hook_task USING btree (repo_id);


--
-- Name: IDX_issue_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_issue_repo_id" ON public.issue USING btree (repo_id);


--
-- Name: IDX_issue_user_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_issue_user_repo_id" ON public.issue_user USING btree (repo_id);


--
-- Name: IDX_issue_user_uid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_issue_user_uid" ON public.issue_user USING btree (uid);


--
-- Name: IDX_label_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_label_repo_id" ON public.label USING btree (repo_id);


--
-- Name: IDX_milestone_repo_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_milestone_repo_id" ON public.milestone USING btree (repo_id);


--
-- Name: IDX_org_user_org_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_org_user_org_id" ON public.org_user USING btree (org_id);


--
-- Name: IDX_org_user_uid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_org_user_uid" ON public.org_user USING btree (uid);


--
-- Name: IDX_public_key_owner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_public_key_owner_id" ON public.public_key USING btree (owner_id);


--
-- Name: IDX_pull_request_issue_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_pull_request_issue_id" ON public.pull_request USING btree (issue_id);


--
-- Name: IDX_repository_lower_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_repository_lower_name" ON public.repository USING btree (lower_name);


--
-- Name: IDX_repository_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_repository_name" ON public.repository USING btree (name);


--
-- Name: IDX_team_org_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_team_org_id" ON public.team USING btree (org_id);


--
-- Name: IDX_team_repo_org_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_team_repo_org_id" ON public.team_repo USING btree (org_id);


--
-- Name: IDX_team_user_org_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_team_user_org_id" ON public.team_user USING btree (org_id);


--
-- Name: UQE_access_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_access_s" ON public.access USING btree (user_id, repo_id);


--
-- Name: UQE_attachment_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_attachment_uuid" ON public.attachment USING btree (uuid);


--
-- Name: UQE_collaboration_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_collaboration_s" ON public.collaboration USING btree (repo_id, user_id);


--
-- Name: UQE_deploy_key_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_deploy_key_s" ON public.deploy_key USING btree (key_id, repo_id);


--
-- Name: UQE_email_address_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_email_address_email" ON public.email_address USING btree (email);


--
-- Name: UQE_follow_follow; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_follow_follow" ON public.follow USING btree (user_id, follow_id);


--
-- Name: UQE_issue_label_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_issue_label_s" ON public.issue_label USING btree (issue_id, label_id);


--
-- Name: UQE_issue_repo_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_issue_repo_index" ON public.issue USING btree (repo_id, index);


--
-- Name: UQE_org_user_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_org_user_s" ON public.org_user USING btree (uid, org_id);


--
-- Name: UQE_protect_branch_protect_branch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_protect_branch_protect_branch" ON public.protect_branch USING btree (repo_id, name);


--
-- Name: UQE_protect_branch_whitelist_protect_branch_whitelist; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_protect_branch_whitelist_protect_branch_whitelist" ON public.protect_branch_whitelist USING btree (repo_id, name, user_id);


--
-- Name: UQE_repository_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_repository_s" ON public.repository USING btree (owner_id, lower_name);


--
-- Name: UQE_star_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_star_s" ON public.star USING btree (uid, repo_id);


--
-- Name: UQE_team_repo_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_team_repo_s" ON public.team_repo USING btree (team_id, repo_id);


--
-- Name: UQE_team_user_s; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_team_user_s" ON public.team_user USING btree (team_id, uid);


--
-- Name: UQE_two_factor_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_two_factor_user_id" ON public.two_factor USING btree (user_id);


--
-- Name: UQE_upload_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_upload_uuid" ON public.upload USING btree (uuid);


--
-- Name: UQE_user_lower_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_user_lower_name" ON public."user" USING btree (lower_name);


--
-- Name: UQE_user_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_user_name" ON public."user" USING btree (name);


--
-- Name: UQE_watch_watch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UQE_watch_watch" ON public.watch USING btree (user_id, repo_id);


--
-- Name: idx_access_token_uid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_access_token_uid ON public.access_token USING btree (uid);


--
-- PostgreSQL database dump complete
--

