Class shvarov.copilot.HelloWorld Extends %RegisteredObject
{

/// This method outputs "Hello, World!" to the console.
ClassMethod SayHello()
{
        Write "Hello, World!",!
}

/// Introduce a method that multiplies parameter by 2
ClassMethod MultiplyByTwo(pValue As %Integer) As %Integer
{
    Quit pValue * 2
}

///    Introduce a method that adds two parameters
ClassMethod AddTwoNumbers(pValue1 As %Integer, pValue2 As %Integer) As %Integer
{
    Quit pValue1 + pValue2
}

/// Classmethod that returns the current date and time
ClassMethod GetDateTime() As %String
{
    Quit $ZDATETIME($HOROLOG,3)
}

}
