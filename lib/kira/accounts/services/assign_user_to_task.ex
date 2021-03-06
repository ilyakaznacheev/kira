defmodule Kira.Accounts.Services.AssignUserToTask do
  @moduledoc """
  Assigns next free `User` to the most important task in the queue.
  """

  use Exop.Operation

  @doc """
  Finds the `User`-task pair to assign.

  Assign rules:
  1. One `User` can only do one task at a time
  2. `User`s can only be assigned if their state is `:active`
  3. `CodeReview`s value more than `Issue`s
  4. `CodeReview`s value by created_date, first in - first out
  5. `CodeReview` can not be performed by the same `User` who created it
  6. `Issue`s value by weight and due date
  7. We only assign `Issue`s if their state is `:queued`

  That's how logic looks like:

    foreach project in kira.projects():
      => transaction
        => operation(Kira.Accounts.Queries.FindFreeDeveloper)
        => operation(Kira.Projects.Services.FindTaskToAssign)
        => operation(Kira.Accounts.Commands.AssignDeveloper)

  """
  def process(_params) do
    # TODO: once the number of projects will become too big,
    # we will need to refactor this code. It is good for now.
    # We can use `Flow` or `GenStage` in the future.
    # https://github.com/mtwilliams/bourne

    # TODO: we need Ecto.Multi for transaction here

    # TODO: move to another usecase
    # => operation(Kira.Accounts.Services.FetchProjectParticipants)
    # => operation(Kira.Projects.Commands.RenewProjectParticipants)
    # Kira.Projects.Queries.ProjectQueries.active_projects()
    # |> Enum.map(&FetchProjectParticipants.run(project_uid: &1.uid))
    # |> Enum.map(&RenewProjectParticipants.run/1)
    # |> Enum.map(&do_assign/1)
  end
end
