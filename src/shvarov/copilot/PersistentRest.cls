Class shvarov.copilot.PersistentRest Extends %CSP.REST
{

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
    Write tResultSet.%SQLCODE, !
    Write tResultSet.%Message, !
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
