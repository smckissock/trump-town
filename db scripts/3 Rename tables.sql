USE TrumpTown
GO


exec sp_rename 'trumptown_datastore_agencies', 'Agencies'
exec sp_rename 'trumptown_datastore_compensation_sources', 'compensation_sources' -- 5261
exec sp_rename 'trumptown_datastore_employment_agreements', 'employment_agreements' -- 17655
exec sp_rename 'trumptown_datastore_employment_assets', 'employment_assets' -- 16,963
exec sp_rename 'trumptown_datastore_gifts', 'gifts' -- 65
exec sp_rename 'trumptown_datastore_liabilities', 'liabilities' -- 1891
exec sp_rename 'trumptown_datastore_lobbyists', 'lobbyists' -- 1675
exec sp_rename 'trumptown_datastore_organization_roles', 'organization_roles' -- 9867
exec sp_rename 'trumptown_datastore_organizations', 'organizations'-- 6687
exec sp_rename 'trumptown_datastore_other_income_assets', 'other_income_assets' -- 40,162
exec sp_rename 'trumptown_datastore_outside_government_positions', 'outside_government_positions' -- 4606
exec sp_rename 'trumptown_datastore_spouse_employment_assets', 'spouse_employment_assets' -- 6899
exec sp_rename 'trumptown_datastore_staffers', 'staffers' -- 2802
exec sp_rename 'trumptown_datastore_transactions', 'transactions' -- 175
