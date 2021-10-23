# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

Rush.Import.import_json_file!("rushing.json")
