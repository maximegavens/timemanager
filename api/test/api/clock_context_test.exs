defmodule Api.ClockContextTest do
  use Api.DataCase

  alias Api.ClockContext

  describe "clocks" do
    alias Api.ClockContext.Clocks

    @valid_attrs %{status: true, time: ~N[2010-04-17 14:00:00]}
    @update_attrs %{status: false, time: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{status: nil, time: nil}

    def clocks_fixture(attrs \\ %{}) do
      {:ok, clocks} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ClockContext.create_clocks()

      clocks
    end

    test "list_clocks/0 returns all clocks" do
      clocks = clocks_fixture()
      assert ClockContext.list_clocks() == [clocks]
    end

    test "get_clocks!/1 returns the clocks with given id" do
      clocks = clocks_fixture()
      assert ClockContext.get_clocks!(clocks.id) == clocks
    end

    test "create_clocks/1 with valid data creates a clocks" do
      assert {:ok, %Clocks{} = clocks} = ClockContext.create_clocks(@valid_attrs)
      assert clocks.status == true
      assert clocks.time == ~N[2010-04-17 14:00:00]
    end

    test "create_clocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClockContext.create_clocks(@invalid_attrs)
    end

    test "update_clocks/2 with valid data updates the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{} = clocks} = ClockContext.update_clocks(clocks, @update_attrs)
      assert clocks.status == false
      assert clocks.time == ~N[2011-05-18 15:01:01]
    end

    test "update_clocks/2 with invalid data returns error changeset" do
      clocks = clocks_fixture()
      assert {:error, %Ecto.Changeset{}} = ClockContext.update_clocks(clocks, @invalid_attrs)
      assert clocks == ClockContext.get_clocks!(clocks.id)
    end

    test "delete_clocks/1 deletes the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{}} = ClockContext.delete_clocks(clocks)
      assert_raise Ecto.NoResultsError, fn -> ClockContext.get_clocks!(clocks.id) end
    end

    test "change_clocks/1 returns a clocks changeset" do
      clocks = clocks_fixture()
      assert %Ecto.Changeset{} = ClockContext.change_clocks(clocks)
    end
  end
end
