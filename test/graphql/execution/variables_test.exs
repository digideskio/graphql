defmodule GraphQL.Execution.Executor.VariableTest do
  use ExUnit.Case, async: true

  import ExUnit.TestHelpers

  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.List
  alias GraphQL.Type.NonNull
  alias GraphQL.Type.String
  alias GraphQL.Type.Input

  IO.inspect GraphQL.Types
  defmodule GraphQL.Type.TestComplexScalar do
    defstruct name: "ComplexScalar", description: ""
  end
  # TODO: Why can't I have a defimpl in here?
  # Should I put this in a support file?
  alias GraphQL.Type.TestComplexScalar

  def test_input_object do
    %Input{
      name: "TestInputObject",
      fields: %{
        a: %{ type: %String{} },
        b: %{ type: %List{ofType: %String{} } },
        c: %{ type: %NonNull{ofType: %String{} } },
        d: %{ type: %TestComplexScalar{} }
      }
    }
  end

  def test_nested_input_object do
    %Input{
      name: "TestNestedInputObject",
      fields: %{
        na: %{ type: %NonNull{ofType: test_input_object } },
        nb: %{ type: %NonNull{ofType: %String{} } }
      }
    }
  end

  def test_type do
    %ObjectType{
      name: "TestType",
      fields: %{
        field_with_object_input: %{
          type: %String{},
          args: %{
            input: %{ type: test_input_object }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        field_with_nullable_string_input: %{
          type: %String{},
          args: %{
            input: %{ type: %String{} }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        field_with_nonnullable_string_input: %{
          type: %String{},
          args: %{
            input: %{ type: %NonNull{ofType: %String{} } }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        field_with_default_parameter: %{
          type: %String{},
          args: %{
            input: %{ type: %String{}, defaultValue: "Hello World" }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        field_with_nested_input: %{
          type: %String{},
          args: %{
            input: %{ type: test_nested_input_object, defaultValue: "Hello World" }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        list: %{
          type: %String{},
          args: %{
            input: %{ type: %List{ofType: %String{} } }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        nnList: %{
          type: %String{},
          args: %{
            input: %{ type: %NonNull{ofType: %List{ofType: %String{} } } }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        listNN: %{
          type: %String{},
          args: %{
            input: %{ type: %List{ofType: %NonNull{ofType: %String{} } } }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        },
        nnListNN: %{
          type: %String{},
          args: %{
            input: %{ type: %NonNull{ofType: %List{ofType: %NonNull{ofType: %String{} } } } }
          },
          resolve: fn(_, %{input: input}, _) -> input end
        }
      } # /fields
    }
  end

  def schema do
    %Schema{ query: test_type }
  end

  test "just don't crash" do
    test_type
  end

end
