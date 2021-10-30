defmodule Rush.ImportTest do
  use Rush.DataCase

  alias Rush.Import
  alias Rush.Rushing.PlayerRush

  describe "import_json_file!/1" do
    test "successfully import all initial records into the database" do
      assert {326, _} = Import.import_json_file!("rushing.json")
      assert 326 == Repo.aggregate(PlayerRush, :count)
    end
  end
end
