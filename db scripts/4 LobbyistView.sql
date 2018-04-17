USE TrumpTown
GO

EXEC DropView 'LobbyistView'
GO

CREATE VIEW LobbyistView
AS
SELECT 
	s.ID StafferId
	, s.agency_id AgencyID
	, a.Name Agency
	, l.client_name Client
	, l.firm_name Firm
	, s.Name Staffer
	--, ISNULL(CONVERT(VARCHAR(20), s.start_date), '') StartDate
	--, ISNULL(CONVERT(VARCHAR(20), s.end_date), '') EndDate
	--, s.position_title_1 Title
FROM Staffers s
JOIN Agencies a ON s.Agency_id = a.ID
JOIN Lobbyists l ON l.staffer_id = s.id
GO


SELECT DISTINCT Client FROM LobbyistView WHERE AgencyID = 46 

SELECT DISTINCT Firm FROM LobbyistView WHERE AgencyID = 46 

SELECT DISTINCT Staffer FROM LobbyistView WHERE AgencyID = 46 


SELECT * FROM LobbyistView WHERE AgencyID = 15

SELECT Count(*), AgencyID FROM LobbyistView GROUP BY AgencyID


SELECT Client FROM LobbyistView WHERE Client IN (SELECT Firm FROM LobbyistView)


--CropLife America

SELECT * FROM  LobbyistView WHERE Firm = 'CropLife America' OR Client = 'CropLife America'

