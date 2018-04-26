Trump Town (https://projects.propublica.org/trump-town/) is a database of Trump administration political appointees, cabinet members and White House staffers. We created it by requesting staffing lists from individual agencies and the Office of Personnel Management. We then used those staff lists to request financial disclosure documents from the Office of Government Ethics and individual agencies. We parsed those financial disclosures to create a relational database that includes tables for organizations (former employers) and agencies, in addition to staffers. We also cross-referenced staffer names from our Represent lobbying database (https://projects.propublica.org/represent/lobbying/), and reviewed those names to verify that the people match.

The database contains 14 tables: five created by ProPublica, as well as nine tables from financial disclosure documents, scraped and cleaned into usable data. The tables are available in the download both as 14 individual CSVs with primary and foreign keys, and a single SQL dump file containing the 14 tables.

The ProPublica tables are:

* staffers
* agencies
* organizations
* organization_roles
* lobbyists

The tables ProPublica scraped or transcribed directly from Personal Financial Disclosure (PFD) forms are:

* compensation_sources
* employment_agreements
* employment_assets
* gifts
* liabilities 
* other_income_assets
* outside_government_positions
* spouse_employment_assets
* transactions


The staffers table and all PFD tables are joinable on the staffer table's id field and every other table's staffer_id field. Staffers and agencies are joined between agencies' id and staffers' agency_id field respectively. 

If a staffer has transferred to another agency, there will be an agency name in the government_transfer column and another row for the staffer's role at that agency. Therefore, there are multiple records for individual people in the database. To get a count of unique appointees across the government, run something akin to `select count(*) from staffers where government_transfer is null`.

The organizations table was created by extracting former employer names from the outside_government_positions and compensation_sources tables. Those entities were then merged and reconciled by hand. Therefore, if one staffer wrote on a PFD that he worked at "Donald J. Trump for President, Inc." and another wrote "Trump for President," we merged those into a single organization object.

Staffers are joined to organizations through the organization_roles table in a many-to-many relationship on staffer_id and organization_id. That table includes a role column that notes whether the staffer is connected to the organization as an outside_government_position or a compensation_source. The role_description field comes from the description of their position with the organization on the PFD. If the "organization" is a personal trust, "confidential client" or other entity that isn't an actual organization, the organization's org_type should be set to "hide." Note that because organization_roles are connected to staffers through both outside_government_positions and compensation_sources, if you want to get a count of unique staffers associated with an organization, you need to unique-ify those queries by staffer_id.

The lobbyists table contains lobbying records for staffers. That table exists in a one to many relationship with staffers on staffers' id field and lobbyists' staffer_id. Staffers can have many "lobbyists," meaning lobbying records. There's also a has_lobbyists convenience column on staffer to note whether or not a staffer has any lobbying records.

In the app, we highlight three special categories of staffers -- lobbyists, staffers with ethics waivers, and special government employees. Besides lobbyists, it's possible to filter for those with ethics waivers by looking for rows that have an ethics_waiver_url. SGEs are denoted in the boolean sge column.

The raw financial disclosure PDF document, from which the data was scraped or transcribed can be found in the staffer financial_disclosure_url field.

All join columns -- staffer_id, organization_id, agency_id -- are autoincrement ids and should not be assumed to be consistent except within a single data load. When we update the dataset, those IDs may change. In staffers, organizations and agencies tables, the slug field generally won't change across loads, and can be assumed to be unique within each table.

For more information on the Public Financial Disclosure tables (e.g. Form 278), please refer to OGE's documentation: https://www.oge.gov/Web/278eGuide.nsf/Chapters/OGE%20Form%20278e?opendocument