USE TrumpTown
GO


--CREATE PROCEDURE [dbo].[DropTable](@table AS varchar(500)) 
--AS
--BEGIN
--	DECLARE @sql nvarchar(500)
--	SET @sql = 'IF OBJECT_ID(''' + @table + ''', ''U'') IS NOT NULL BEGIN DROP TABLE ' + @table + ' END'
--	EXEC sp_executesql @sql
--END	

--GO	
	
--CREATE PROCEDURE [dbo].[DropView](@view AS varchar(500)) 
--AS
--BEGIN
--	DECLARE @sql nvarchar(500)
--	SET @sql = 'IF OBJECT_ID(''' + @view + ''', ''V'') IS NOT NULL BEGIN DROP VIEW ' + @view + ' END'
--	EXEC sp_executesql @sql
--END	


EXEC DropTable 'trumptown_datastore_agencies'
GO
EXEC DropTable 'trumptown_datastore_compensation_sources'
GO
EXEC DropTable 'trumptown_datastore_employment_agreements'
GO
EXEC DropTable 'trumptown_datastore_employment_assets'
GO
EXEC DropTable 'trumptown_datastore_gifts'
GO
EXEC DropTable 'trumptown_datastore_liabilities'
GO
EXEC DropTable 'trumptown_datastore_lobbyists'
GO
EXEC DropTable 'trumptown_datastore_organization_roles'
GO
EXEC DropTable 'trumptown_datastore_organizations'
GO
EXEC DropTable 'trumptown_datastore_other_income_assets'
GO
EXEC DropTable 'trumptown_datastore_outside_government_positions'
GO
EXEC DropTable 'trumptown_datastore_spouse_employment_assets'
GO
EXEC DropTable 'trumptown_datastore_staffers'
GO
EXEC DropTable 'trumptown_datastore_transactions'
GO


--CREATE TABLE [dbo].[UserGroup](
--	[ID] [int] IDENTITY(1,1) NOT NULL,
--	[Name] [varchar](200) UNIQUE NOT NULL,
--	[EditTime] [datetime2](6) NOT NULL CONSTRAINT [DF_UserGroup_EditTime]  DEFAULT (getdate()),
--	[EditorID] [int] NOT NULL CONSTRAINT [DF_UserGroup_EditorID]  DEFAULT ((1)),
-- CONSTRAINT [PK_UserGroup] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO


CREATE TABLE trumptown_datastore_agencies (
    id integer PRIMARY KEY,
    name VARCHAR(MAX),
    slug VARCHAR(MAX),
    ap_name VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_compensation_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_compensation_sources (
    id integer  PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    source_name VARCHAR(MAX),
    city_state VARCHAR(MAX),
    brief_description_of_duties VARCHAR(MAX),
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_employment_agreements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_employment_agreements (
    id integer  PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    employer_or_party VARCHAR(MAX),
    city_state VARCHAR(MAX),
    status_and_terms VARCHAR(MAX),
    date date,
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_employment_assets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_employment_assets (
    id integer PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    description VARCHAR(MAX),
    eif VARCHAR(MAX),
    value VARCHAR(MAX),
    income_type VARCHAR(MAX),
    income_amount VARCHAR(MAX),
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_gifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_gifts (
    id integer PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    source_name VARCHAR(MAX),
    city_state VARCHAR(MAX),
    brief_description VARCHAR(MAX),
    value VARCHAR(MAX),
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_liabilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_liabilities (
    id integer PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    creditor_name VARCHAR(MAX),
    creditor_type VARCHAR(MAX),
    amount VARCHAR(MAX),
    year_incurred integer,
    rate VARCHAR(MAX),
    term VARCHAR(MAX),
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_lobbyists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_lobbyists (
    id integer PRIMARY KEY,
    employee_name VARCHAR(MAX),
    lobbyist_name VARCHAR(MAX),
    lobbyist_covered_positions VARCHAR(MAX),
    client_name VARCHAR(MAX),
    client_description VARCHAR(MAX),
    firm_name VARCHAR(MAX),
    firm_description VARCHAR(MAX),
    url VARCHAR(MAX),
    staffer_id integer
);


--
-- Name: trumptown_datastore_organization_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_organization_roles (
    id integer PRIMARY KEY,
    organization_id integer,
    staffer_id integer,
    role VARCHAR(MAX),
    role_description VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_organizations (
    id integer PRIMARY KEY,
    name VARCHAR(MAX),
    img_url VARCHAR(MAX),
    city VARCHAR(MAX),
    state VARCHAR(MAX),
    slug VARCHAR(MAX),
    org_type VARCHAR(MAX),
    hide bit,
    org_group VARCHAR(MAX),
    organization_category_id integer
);


--
-- Name: trumptown_datastore_other_income_assets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_other_income_assets (
    id integer PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    description VARCHAR(MAX),
    eif VARCHAR(MAX),
    value VARCHAR(MAX),
    income_type VARCHAR(MAX),
    income_amount VARCHAR(MAX),
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_outside_government_positions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_outside_government_positions (
    id integer PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    organization_name VARCHAR(MAX),
    city_state VARCHAR(MAX),
    organization_type VARCHAR(MAX),
    position_held VARCHAR(MAX),
    from_date date,
    to_date date,
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_spouse_employment_assets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_spouse_employment_assets (
    id integer PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    description VARCHAR(MAX),
    eif VARCHAR(MAX),
    value VARCHAR(MAX),
    income_type VARCHAR(MAX),
    income_amount VARCHAR(MAX),
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_staffers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_staffers (
    id integer PRIMARY KEY,
    agency_name VARCHAR(MAX),
    name VARCHAR(MAX),
    position_title_1 VARCHAR(MAX),
    position_title_2 VARCHAR(MAX),
    position_title_3 VARCHAR(MAX),
    grade_level VARCHAR(MAX),
    start_date date,
    end_date date,
    financial_disclosure_url VARCHAR(MAX),
    ethics_waiver_url VARCHAR(MAX),
    image_url VARCHAR(MAX),
    reason_for_missing_report VARCHAR(MAX),
    agency_id integer,
    slug VARCHAR(MAX),
    has_lobbyists bit,
    taskforce_member bit,
    taskforce_title VARCHAR(MAX),
    taskforce_agency VARCHAR(MAX),
    agency_slug VARCHAR(MAX),
    senate_lobbying_confirmation bit,
    last_year_lobbied integer,
    senate_lobbying_url VARCHAR(MAX),
    linkedin_url VARCHAR(MAX),
    outside_bio VARCHAR(MAX),
    bio_source VARCHAR(MAX),
    bio_url VARCHAR(MAX),
    sge bit,
    last_name VARCHAR(MAX),
    awaiting_senate_confirmation bit,
    nomination_appointment_failed bit,
    government_transfer VARCHAR(MAX),
    propublica_bio VARCHAR(MAX)
);


--
-- Name: trumptown_datastore_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trumptown_datastore_transactions (
    id integer PRIMARY KEY,
    filename VARCHAR(MAX),
    line_number VARCHAR(MAX),
    description VARCHAR(MAX),
    transaction_type VARCHAR(MAX),
    date date,
    amount VARCHAR(MAX),
    staffer_id integer,
    organization_id integer,
    organization_slug VARCHAR(MAX),
    pfd_endnote VARCHAR(MAX)
);
