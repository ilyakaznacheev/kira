defmodule KiraWeb.Webhooks.IssueWebhook do
  @moduledoc """
  Parses and processes `Issue` webhooks.
  """

  alias Kira.Usecases

  # TODO: make perform_command a behaviour
  def perform_command(webhook_data) do
    %{
      "object_attributes" => %{
        "action" => action
      }
    } = webhook_data

    action
    |> select_command()
    |> apply(:run, [structure_payload(webhook_data)])
  end

  defp select_command("open"), do: Usecases.SaveIssueFromWebhook
  defp select_command("update"), do: Usecases.UpdateIssueFromWebhook
  defp select_command("close"), do: Usecases.CloseIssueFromWebhook

  defp structure_payload(webhook_data) do
    %{
      "object_kind" => "issue",
      "project" => %{"id" => project_uid},
      "object_attributes" => %{
        "author_id" => author_uid,
        "assignee_id" => assignee_uid,
        "id" => issue_uid,
        "iid" => issue_iid,
        "state" => issue_state,
        "weight" => issue_weight,
        "due_date" => issue_due_date
      }
    } = webhook_data

    [
      project_uid: project_uid,
      author_uid: author_uid,
      assignee_uid: assignee_uid,
      # TODO: here I mix string and atom keys. Needs a fix
      attrs: %{
        "uid" => issue_uid,
        "iid" => issue_iid,
        "state" => issue_state,
        "weight" => issue_weight,
        "due_date" => issue_due_date
      }
    ]
  end
end
