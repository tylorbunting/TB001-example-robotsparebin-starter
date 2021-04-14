*** Settings ***
Documentation     Robot to enter weekly sales data into the RobotSpareBin Industries Intranet.
Library           RPA.Browser.Selenium 
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.PDF


*** Keywords ***
Open the Intranet Website
    Open Available Browser    https://robotsparebinindustries.com/    


*** Keywords ***
Log In
    Input Text    username    maria
    Input Password    password    thoushallnotpass
    Submit Form
    Wait Until Page Contains Element    id:sales-form


*** Keywords ***
Download The Excel File
    Download    https://robotsparebinindustries.com/SalesData.xlsx  overwrite=True


*** Keywords ***
Fill And Submit The Form
    Input Text    firstname    Tylordhellowworld
    Input Text    lastname    Bunting
    Input Text    salesresult    123
    Select From List By Value    salestarget    10000
    Click Button    Submit


*** Keywords ****
Fill And Submit The Form Using Excel Data
    Open Workbook    SalesData.xlsx
    ${sales_reps}=      Read Worksheet As Table     header=True
    Close Workbook
    FOR     ${sales_rep}   IN  @{sales_reps}
        Fill And Submit The Form For One Person    ${sales_rep}
    END


*** Keywords ***
Fill And Submit The Form For One Person
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult    ${sales_rep}[Sales]
    ${target_as_string}     Convert To String       ${sales_rep}[Sales Target]
    Select From List By Value    salestarget    ${target_as_string}
    Click Button    Submit    


*** Keywords ***
Log Out And Close The Browser
    Click Button    Log out
    Close Browser


*** Keywords ***
Collect The Results
    Screenshot    css:div.sales-summary     ${CURDIR}${/}output${/}sales_summary.png


*** Keywords ****
Export The Table As PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=      Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf     ${sales_results_html}    ${CURDIR}${/}output${/}sales_results.pdf


*** Tasks ***
Insert the sales datta for the week and export it as a PDF
    Open the Intranet Website
    Log In
    Download The Excel File
    Fill And Submit The Form Using Excel Data
    Collect The Results
    Export The Table As PDF
    [Teardown]  Log Out And Close The Browser
