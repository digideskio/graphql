defmodule GraphqlLexerTest do
  use ExUnit.Case

  def assert_tokens(input, tokens) do
    case :graphql_lexer.string(input) do
      {:ok, output, _} ->
        assert output == tokens
      {:error, {_, :graphql_lexer, output}, _} ->
        assert output == tokens
    end
  end

  # Ignored tokens
  test "WhiteSpace is ignored" do
    assert_tokens '\x{0009}', [] # horizontal tab
    assert_tokens '\x{000B}', [] # vertical tab
    assert_tokens '\x{000C}', [] # form feed
    assert_tokens '\x{0020}', [] # space
    assert_tokens '\x{00A0}', [] # non-breaking space
  end

  test "LineTerminator is ignored" do
    assert_tokens '\x{000A}', [] # new line
    assert_tokens '\x{000D}', [] # carriage return
    assert_tokens '\x{2028}', [] # line separator
    assert_tokens '\x{2029}', [] # paragraph separator
  end

  test "Comment is ignored" do
    assert_tokens '# some comment', []
  end

  test "Comma is ignored" do
    assert_tokens ',', []
  end

  # Lexical tokens
  test "Punctuator" do
    assert_tokens '!', [{ :punctuator, 1, '!' }]
    assert_tokens '$', [{ :punctuator, 1, '$' }]
    assert_tokens '(', [{ :punctuator, 1, '(' }]
    assert_tokens ')', [{ :punctuator, 1, ')' }]
    assert_tokens ':', [{ :punctuator, 1, ':' }]
    assert_tokens '=', [{ :punctuator, 1, '=' }]
    assert_tokens ':', [{ :punctuator, 1, ':' }]
    assert_tokens '@', [{ :punctuator, 1, '@' }]
    assert_tokens '[', [{ :punctuator, 1, '[' }]
    assert_tokens ']', [{ :punctuator, 1, ']' }]
    assert_tokens '{', [{ :punctuator, 1, '{' }]
    assert_tokens '|', [{ :punctuator, 1, '|' }]
    assert_tokens '}', [{ :punctuator, 1, '}' }]
    assert_tokens '...', [{ :punctuator, 1, '...' }]
  end

  test "Name" do
    assert_tokens '_', [{ :name, 1, '_' }]
    assert_tokens 'a', [{ :name, 1, 'a' }]
    assert_tokens 'Z', [{ :name, 1, 'Z' }]
    assert_tokens 'foo', [{ :name, 1, 'foo' }]
    assert_tokens 'Foo', [{ :name, 1, 'Foo' }]
    assert_tokens '_foo', [{ :name, 1, '_foo' }]
    assert_tokens 'foo0', [{ :name, 1, 'foo0' }]
    assert_tokens '_foo_Bar_QUUX_2139', [{ :name, 1, '_foo_Bar_QUUX_2139' }]
    assert_tokens 'a-b', { :illegal, '-' }
  end

end