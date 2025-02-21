Class shvarov.copilot.Persistent Extends %Persistent
{

Property Name As %String;

Property Age As %Integer;

Property Surname As %String;

/// add random 10 values
ClassMethod AddRandomValues()
{
    Set names = "John,Mary,Alex,Jane,Michael,Sarah,David,Emma,Chris,Olivia"
    Set surnames = "Smith,Johnson,Williams,Brown,Jones,Garcia,Miller,Davis,Martinez,Lopez"
    Set nameList = $LENGTH(names, ",")
    Set surnameList = $LENGTH(surnames, ",")

    For i=1:1:10 {
        Set obj = ##class(shvarov.copilot.Persistent).%New()
        Set obj.Name = $PIECE(names, ",", $Random(nameList) + 1)
        Set obj.Age = $Random(100)
        Set obj.Surname = $PIECE(surnames, ",", $Random(surnameList) + 1)
        Do obj.%Save()
    }
}

/// Classmethod that returns all the records of the class
ClassMethod GetAllRecords()
{
    &sql(DECLARE myCursor CURSOR FOR SELECT Name, Age, Surname FROM shvarov_copilot.Persistent)
    &sql(OPEN myCursor)
    While (SQLCODE = 0) {
        &sql(FETCH myCursor INTO :name, :age, :surname)
        If (SQLCODE = 0) {
            Write !, "Name: ", name, ", Age: ", age, ", Surname: ", surname
        }
    }
    &sql(CLOSE myCursor)
}

/// Classmethod that deletes all the records of the class
ClassMethod DeleteAllRecords()
{
    &sql(DELETE FROM shvarov_copilot.Persistent)
}

Storage Default
{
<Data name="PersistentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>Surname</Value>
</Value>
</Data>
<DataLocation>^shvarov.copilot.PersistentD</DataLocation>
<DefaultData>PersistentDefaultData</DefaultData>
<IdLocation>^shvarov.copilot.PersistentD</IdLocation>
<IndexLocation>^shvarov.copilot.PersistentI</IndexLocation>
<StreamLocation>^shvarov.copilot.PersistentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
