defmodule UndiOnline.Billing.Stripe.CreateCustomerWorkerTest do
  use UndiOnline.DataCase, async: true
  # This line might or might not be required. Uncomment if so.
  # use Oban.Testing, repo: UndiOnline.Repo

  import UndiOnline.UsersFixtures

  alias UndiOnline.Billing
  alias UndiOnline.Billing.Stripe.CreateCustomerWorker

  describe "create customer worker" do
    test "calls the stripe service to create the customer and store stripe id on the customer" do
      user = user_fixture()
      customer = Billing.get_billing_customer_for_user(user)
      assert customer.remote_id == nil

      assert :ok = perform_job(CreateCustomerWorker, %{"id" => customer.id})
      assert %{remote_id: "" <> _} = Billing.get_billing_customer_for_user(user)
    end
  end
end
