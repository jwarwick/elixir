Code.require_file "../test_helper", __FILE__

defmodule EExTest do
  use ExUnit::Case

  test "compile simple string" do
    assert_eval "foo bar", "foo bar"
  end

  test "compile with embedded" do
    assert_eval "foo bar", "foo <%= :bar %>"
  end

  test "compile with embedded do end" do
    assert_eval "foo bar", "foo <% if true do %>bar<% end %>"
  end

  test "compile with embedded do end and eval the expression" do
    assert_eval "foo ", "foo <% if false do %>bar<% end %>"
  end

  test "compile with embedded do end and nested print expression" do
    assert_eval "foo bar", "foo <% if true do %><%= :bar %><% end %>"
  end

  test "compile with embedded do end and nested expression" do
    assert_eval "foo ", "foo <% if true do %><% 1 + 2 %><% end %>"
  end

  test "compile with embedded middle expression" do
    assert_eval "foo bar", "foo <% if true do %>bar<% else: %>baz<% end %>"
  end

  test "compile with embedded middle expression and eval the expression" do
    assert_eval "foo baz", "foo <% if false do %>bar<% else: %>baz<% end %>"
  end

  defp assert_eval(expected, atual) do
    compiled = EEx.compile(atual)
    { result, _ } = Code.eval_quoted(compiled, [], __FILE__, __LINE__)
    assert_equal expected, result
  end
end
