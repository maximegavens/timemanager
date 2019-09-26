defmodule Api.SwaggerContext.Swagger do
  use PhoenixSwagger


  def swagger_definitions do
    %{
      users: swagger_schema do
        title "User"
        description "A user of the application"
        properties do
          username :string, "Users username", required: true
          email :string, "email address", required: true
          role :string, "status in the company", required: true
          password :string, "hidden password", required: true, virtual: true
          password_hash :string, "crypted password"
          team :string, "number of the user's team", required: true
          workingtimes Schema.ref(:workingtimes)
          clocks Schema.ref(:clocks)
        end
        example %{
          name: "paul",
          email: "paul@exe.com",
          role: "manager",
          password: "admin",
          team: "1",
        }
      end,
      clocks: swagger_schema do
        title "Clock"
        description "A clocks of the application, one clock in and one clock out generate a workingtimes"
        properties do
          status :boolean, "true if user starting to work, false if user stop"
          time :naive_datetime, "date and time when clock occurs"
          user Schema.ref(:users)
        end
        example %{
          status: "true",
          time: "2019-09-25 07:54:00",
          user_id: "7",
        }
      end,
      workingtimes: swagger_schema do
        title "Workingtime"
        description "A workingtimes of the application"
        properties do
          start :naive_datetime, "date and time where the user starts to work", required: true
          endd :naive_datetime, "date and time where the user stops to work", required: true
          user Schema.ref(:users)
        end
        example %{
          start: "2019-09-25 07:54:00",
          end: "2019-09-25 17:09:00",
          user_id: "7",
        }
      end,
    }
  end
end
