Class shvarov.copilot.PersistentRest Extends %CSP.REST
{

ClassMethod SetupSecurity() As %Status
{
    Set tSC = $$$OK
    d ..IntroduceRoleCopilot()
    d ..AddRole()
    Quit tSC
}

ClassMethod IntroduceRoleCopilot() As %Status
{
    &SQL(CREATE ROLE copilot)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error creating role: "_SQLCODE)
    }
    &SQL(GRANT SELECT on shvarov_copilot.Persistent to copilot)
    If SQLCODE '= 0 {
        Quit $$$ERROR($$$GeneralError, "Error granting privileges: "_SQLCODE)
    }
    Quit $$$OK
}

ClassMethod AddRole(appname = "/copilot", approle = "copilot") As %Status
{
    // Change to the %SYS namespace.
    new $NAMESPACE
    set $NAMESPACE="%SYS"

    set status=##class(Security.Applications).Get(appname, .MyAppProps)
    set MyAppProps("MatchRoles")=MyAppProps("MatchRoles")_":"_approle

    set status=##class(Security.Applications).Modify(appname,.MyAppProps)

    // Announce success.
    if $$$ISOK(status) {
        write !, "Roles were successfully modified."
    }
    Quit status
}

ClassMethod ReadRoles(appname = "/copilot") As %Status
{
    // Change to the %SYS namespace.
    new $NAMESPACE
    set $NAMESPACE="%SYS"

    // Retrieve the current roles for the application.
    set status=##class(Security.Applications).Get(appname, .MyAppProps)

    // Check if the operation was successful.
    if $$$ISOK(status) {
        // Output the current MatchRoles property.
        write !, "Current roles: ", MyAppProps("MatchRoles")
    } else {
        write !, "Failed to retrieve roles."
    }

    return status
}

ClassMethod GetRecord(id As %String) As %Status
{
    Set tSC = $$$OK
    Try {
        Set record = ##class(shvarov.copilot.Persistent).%OpenId(id)
        If record = "" {
            Set tSC = $$$ERROR($$$GeneralError, "Record not found")
        } Else {
            Do %response.WriteJSONStream(record.%JSONExport())
        }
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    Quit tSC
}

ClassMethod PostRecord() As %Status
{
    Set tSC = $$$OK
    Try {
        Set request = ##class(%Object).%New()
        Do request.%JSONImport(%request.Content.Read())
        Set record = ##class(shvarov.copilot.Persistent).%New()
        Do record.%JSONImport(request)
        Set tSC = record.%Save()
        If $$$ISOK(tSC) {
            Do %response.WriteJSONStream(record.%JSONExport())
        }
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    Quit tSC
}

ClassMethod PutRecord(id As %String) As %Status
{
    Set tSC = $$$OK
    Try {
        Set record = ##class(shvarov.copilot.Persistent).%OpenId(id)
        If record = "" {
            Set tSC = $$$ERROR($$$GeneralError, "Record not found")
        } Else {
            Set request = ##class(%Object).%New()
            Do request.%JSONImport(%request.Content.Read())
            Do record.%JSONImport(request)
            Set tSC = record.%Save()
            If $$$ISOK(tSC) {
                Do %response.WriteJSONStream(record.%JSONExport())
            }
        }
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    Quit tSC
}

ClassMethod GetAllRecords() As %Status
{
    Set tResult = []
    Set tResultSet = ##class(%SQL.Statement).%ExecDirect(,"SELECT ID, Name, Surname, Age FROM shvarov_copilot.Persistent")
    //Write tResultSet.%SQLCODE, !
    //Write tResultSet.%Message, !
    While tResultSet.%Next() {

        Set tRecord = ##class(%DynamicObject).%New()
        Do tRecord.%Set("ID", tResultSet.ID)
        Do tRecord.%Set("Name", tResultSet.Name)
        Do tResult.%Push(tRecord)

    }

    Do tResult.%ToJSON()
    Quit $$$OK
}

XData UrlMap
{
<Routes>
        <Route Url="/record/:id" Method="GET" Call="GetRecord"/>
        <Route Url="/record" Method="POST" Call="PostRecord"/>
        <Route Url="/record/:id" Method="PUT" Call="PutRecord"/>
        <Route Url="/records" Method="GET" Call="GetAllRecords"/>
    </Routes>
}

}
