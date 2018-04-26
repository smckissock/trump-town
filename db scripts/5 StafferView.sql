USE TrumpTown
GO


EXEC DropView 'StafferView'
GO

CREATE VIEW StafferView
AS

SELECT 
	id
	, agency_id 
	, name
	, slug
	, agency_name 
	, position_title_1
	, position_title_2
	, position_title_3
	, grade_level
	, start_date
	, end_date
	, financial_disclosure_url
	, ethics_waiver_url
	, linkedin_url
	, outside_bio
	, bio_source
	, bio_url
	, propublica_bio
FROM Staffers
WHERE ID IN (SELECT staffer_id FROM lobbyists) -- Only former lobbyists (for now)
AND government_transfer IS NULL  -- Only include current staffers.  This leaves out a persons prior positions in administration! 
	 