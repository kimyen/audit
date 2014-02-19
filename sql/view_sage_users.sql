-- Internal Sage users
CREATE OR REPLACE VIEW VIEW_SAGE_USERS AS
SELECT
    UG.ID AS PRINCIPAL_ID,
    UG.CREATION_DATE AS CREATED_ON,
    GM.GROUP_ID AS GROUP_ID,
    PA.ALIAS_DISPLAY AS EMAIL
FROM
    JDOUSERGROUP UG
    JOIN PRINCIPAL_ALIAS PA ON UG.ID = PA.PRINCIPAL_ID
    -- Some users, like 'anonymous@sageabase.org', are not associated with any group thus the left outer join
    LEFT JOIN GROUP_MEMBERS GM ON UG.ID = GM.MEMBER_ID 
WHERE
    UG.ISINDIVIDUAL = true AND
    PA.TYPE = 'USER_EMAIL' AND (
        GM.GROUP_ID = 273957 OR -- The Sage Employee Team
        GM.GROUP_ID = 2 OR      -- The Administrators Team
        PA.ALIAS_DISPLAY IN (
           'some.guy@gmail.com') OR -- Ask for the list
        PA.ALIAS_DISPLAY LIKE '%@sagebase.org' OR
        PA.ALIAS_DISPLAY LIKE '%@jayhodgson.com');


-- Non-Sage users
CREATE OR REPLACE VIEW VIEW_NON_SAGE_USERS AS
SELECT
    UG.ID AS PRINCIPAL_ID,
    UG.CREATION_DATE AS CREATED_ON,
    PA.ALIAS_DISPLAY AS EMAIL
FROM
    JDOUSERGROUP UG,
    PRINCIPAL_ALIAS PA
WHERE
    UG.ID = PA.PRINCIPAL_ID AND
    UG.ISINDIVIDUAL = true AND
    PA.TYPE = 'USER_EMAIL' AND
    UG.ID NOT IN(
        SELECT PRINCIPAL_ID FROM VIEW_SAGE_USERS
    );

-- Unit tests
SELECT * FROM VIEW_SAGE_USERS;

SELECT * FROM VIEW_NON_SAGE_USERS;
