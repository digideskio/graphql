Nonterminals
  Document
  Definitions Definition OperationDefinition FragmentDefinition
  SelectionSet Selections Selection
  OperationType Name VariableDefinitions VariableDefinition Directives Directive
  Field Alias Arguments ArgumentList Argument
  FragmentSpread FragmentName InlineFragment
  VariableDefinitionList Variable DefaultValue
  Type TypeCondition NamedType ListType NonNullType
  Value EnumValue ListValue Values ObjectValue ObjectFields ObjectField.

Terminals
  '{' '}' '(' ')' '[' ']' '!' ':' '@' '$' '=' '...' 'query' 'mutation' 'fragment' 'on'
  name int_value float_value string_value boolean_value.

Rootsymbol Document.

Document -> Definitions : build_ast_node('Document', {'definitions', '$1'}).

Definitions -> Definition : ['$1'].
Definitions -> Definition Definitions : ['$1'|'$2'].

Definition -> OperationDefinition : '$1'.
Definition -> FragmentDefinition : '$1'.

OperationType -> 'query' : extract_atom('$1').
OperationType -> 'mutation' : extract_atom('$1').

OperationDefinition -> SelectionSet : build_ast_node('OperationDefinition', [{'operation', 'query'}, {'selectionSet', '$1'}]).
OperationDefinition -> OperationType Name SelectionSet : build_ast_node('OperationDefinition', [{'operation', '$1'}, {'name', '$2'}, {'selectionSet', '$3'}]).
OperationDefinition -> OperationType Name VariableDefinitions SelectionSet : build_ast_node('OperationDefinition', [{'operation', '$1'}, {'name', '$2'}, {'variableDefinitions', '$3'}, {'selectionSet', '$4'}]).
OperationDefinition -> OperationType Name Directives SelectionSet : build_ast_node('OperationDefinition', [{'operation', '$1'}, {'name', '$2'}, {'directives', '$3'}, {'selectionSet', '$4'}]).
OperationDefinition -> OperationType Name VariableDefinitions Directives SelectionSet : build_ast_node('OperationDefinition', [{'operation', '$1'}, {'name', '$2'}, {'variableDefinitions', '$3'}, {'directives', '$4'}, {'selectionSet', '$5'}]).

FragmentDefinition -> 'fragment' FragmentName 'on' TypeCondition SelectionSet : build_ast_node('FragmentDefinition', [{'name', '$2'}, {'typeCondition', '$4'}, {'selectionSet', '$5'}]).
FragmentDefinition -> 'fragment' FragmentName 'on' TypeCondition Directives SelectionSet : build_ast_node('FragmentDefinition', [{'name', '$2'}, {'typeCondition', '$4'}, {'directives', '$5'}, {'selectionSet', '$6'}]).

TypeCondition -> NamedType : '$1'.

VariableDefinitions -> '(' VariableDefinitionList ')' : '$2'.
VariableDefinitionList -> VariableDefinition : ['$1'].
VariableDefinitionList -> VariableDefinition VariableDefinitionList : ['$1'|'$2'].
VariableDefinition -> Variable ':' Type : build_ast_node('VariableDefinition', [{'variable', '$1'}, {'type', '$3'}]).
VariableDefinition -> Variable ':' Type DefaultValue : build_ast_node('VariableDefinition', [{'variable', '$1'}, {'type', '$3'}, {'defaultValue', '$4'}]).
Variable -> '$' Name : build_ast_node('Variable', [{'name', '$2'}]).

DefaultValue -> '=' Value : '$2'.

Type -> NamedType : '$1'.
Type -> ListType : '$1'.
Type -> NonNullType : '$1'.
NamedType -> Name : build_ast_node('NamedType', [{'name', '$1'}]).
ListType -> '[' Type ']' : build_ast_node('ListType', [{'type', '$2'}]).
NonNullType -> NamedType '!' : build_ast_node('NonNullType', [{'type', '$1'}]).
NonNullType -> ListType '!' : build_ast_node('NonNullType', [{'type', '$1'}]).

SelectionSet -> '{' Selections '}' : build_ast_node('SelectionSet', {'selections', '$2'}).

Selections -> Selection : ['$1'].
Selections -> Selection Selections : ['$1'|'$2'].

Selection -> Field : '$1'.
Selection -> FragmentSpread : '$1'.
Selection -> InlineFragment : '$1'.

FragmentSpread -> '...' FragmentName : build_ast_node('FragmentSpread', [{'name', '$2'}]).
FragmentSpread -> '...' FragmentName Directives : build_ast_node('FragmentSpread', [{'name', '$2'}, {'directives', '$3'}]).

InlineFragment -> '...' 'on' TypeCondition SelectionSet : build_ast_node('InlineFragment', [{'typeCondition', '$3'}, {'selectionSet', '$4'}]).
InlineFragment -> '...' 'on' TypeCondition Directives SelectionSet : build_ast_node('InlineFragment', [{'typeCondition', '$3'}, {'directives', '$4'}, {'selectionSet', '$5'}]).

FragmentName -> Name : '$1'.

Field -> Name : build_ast_node('Field', {'name', '$1'}).
Field -> Name SelectionSet : build_ast_node('Field', [{'name', '$1'}, {'selectionSet', '$2'}]).
Field -> Name Arguments : build_ast_node('Field', [{'name', '$1'}, {'arguments', '$2'}]).
Field -> Name Arguments SelectionSet : build_ast_node('Field', [{'name', '$1'}, {'arguments', '$2'}, {'selectionSet', '$3'}]).
Field -> Alias Name : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}]).
Field -> Alias Name Arguments : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}, {'arguments', '$3'}]).
Field -> Alias Name SelectionSet : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}, {'selectionSet', '$3'}]).
Field -> Alias Name Arguments SelectionSet : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}, {'arguments', '$3'}, {'selectionSet', '$4'}]).
Field -> Alias Name Directives : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}, {'directives', '$3'}]).
Field -> Alias Name Arguments Directives : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}, {'arguments', '$3'}, {'directives', '$4'}]).
Field -> Alias Name Directives SelectionSet : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}, {'directives', '$3'}, {'selectionSet', '$4'}]).
Field -> Alias Name Arguments Directives SelectionSet : build_ast_node('Field', [{'alias', '$1'}, {'name', '$2'}, {'arguments', '$3'}, {'directives', '$4'}, {'selectionSet', '$5'}]).

Alias -> Name ':' : '$1'.

Arguments -> '(' ArgumentList ')' : '$2'.
ArgumentList -> Argument : ['$1'].
ArgumentList -> Argument ArgumentList : ['$1'|'$2'].
Argument -> Name ':' Value : build_ast_node('Argument', [{name, '$1'}, {value, '$3'}]).

Directives -> Directive : ['$1'].
Directives -> Directive Directives : ['$1'|'$2'].
Directive -> '@' Name : build_ast_node('Directive', [{name, '$2'}]).
Directive -> '@' Name Arguments : build_ast_node('Directive', [{name, '$2'}, {'arguments', '$3'}]).

Name -> name : extract_token('$1').

Value -> Variable : '$1'.
Value -> int_value : build_ast_node('IntValue', [{'value', extract_integer('$1')}]).
Value -> float_value : build_ast_node('FloatValue', [{'value', extract_float('$1')}]).
Value -> string_value : build_ast_node('StringValue', [{'value', extract_token('$1')}]).
Value -> boolean_value : build_ast_node('BooleanValue', [{'value', extract_boolean('$1')}]).
Value -> EnumValue : build_ast_node('EnumValue', [{'value', '$1'}]).
Value -> ListValue : build_ast_node('ListValue', [{'values', '$1'}]).
Value -> ObjectValue : build_ast_node('ObjectValue', [{'fields', '$1'}]).

EnumValue -> Name : '$1'.

ListValue -> '[' ']' : [].
ListValue -> '[' Values ']' : '$2'.
Values -> Value : ['$1'].
Values -> Value Values : ['$1'|'$2'].

ObjectValue -> '{' '}' : [].
ObjectValue -> '{' ObjectFields '}' : '$2'.
ObjectFields -> ObjectField : ['$1'].
ObjectFields -> ObjectField ObjectFields : ['$1'|'$2'].
ObjectField -> Name ':' Value : build_ast_node('ObjectField', [{'name', '$1'}, {'value', '$3'}]).

Erlang code.

extract_atom({Value, _Line}) -> Value.
extract_token({_Token, _Line, Value}) -> Value.
extract_integer({_Token, _Line, Value}) ->
  {Int, []} = string:to_integer(Value), Int.
extract_float({_Token, _Line, Value}) ->
  {Float, []} = string:to_float(Value), Float.
extract_boolean({_Token, _Line, "true"}) -> true;
extract_boolean({_Token, _Line, "false"}) -> false.

build_ast_node(Type, Tuple) when is_list(Tuple) ->
  [{kind, Type}, {loc, [{start, 0}]}] ++ Tuple;
build_ast_node(Type, Tuple) when is_tuple(Tuple) ->
  [{kind, Type}, {loc, [{start, 0}]}, Tuple].
