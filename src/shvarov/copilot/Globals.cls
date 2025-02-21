Class shvarov.copilot.Globals Extends %RegisteredObject
{

/// Classmethod that sets a value to a global
ClassMethod SetGlobalValue(pGlobal As %String, pValue As %String) As %Status
{
        Set ^Global(pGlobal) = pValue
        Quit $$$OK
}

/// Classmethod that gets a value from a arbitrary node
ClassMethod GetGlobalValue(pGlobal As %String) As %String
{
        Quit $Get(^Global(pGlobal))
}

/// Classmethod that adds 100 nodes to a global with random values
ClassMethod AddNodes()
{
        For i=1:1:100 {
                Set ^Global("Node"_i) = $Random(100)
        }
}

/// Classmethod that returns the number of nodes in a global
ClassMethod GetNodesCount() As %Integer
{
        Set i=0
        For {
                Set i = i + 1
                Quit:'$Data(^Global("Node"_i))
        }
        Quit i
}

/// Classmethod that returns the sum of all nodes in a global
ClassMethod GetNodesSum() As %Integer
{
        Set i=0, sum=0
        For {
                Set i = i + 1
                Quit:'$Data(^Global("Node"_i))
                Set sum = sum + ^Global("Node"_i)
        }
        Quit sum
}

/// Classmethod that returns the sum of all nodes in a global using $Order
ClassMethod GetNodesSumUsingOrder() As %Integer
{
        Set sum=0
        Set node=""
        For {
                Set node = $Order(^Global(node))
                Quit:node=""
                Set sum = sum + ^Global(node)
        }
        Quit sum
}

}
