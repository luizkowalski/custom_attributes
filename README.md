# Custom attributes

We have three classes: `User`, `Company` and `CustomAttribute`. A user belongs
to a company and the company can define a list of custom attributes they want to
save (`custom_data`).

Through `Customizable` concern, we define the business rule to allow any
company define a field, save it and search for it.

### Implementation

Breaking down `Customizable`:


```ruby
define_singleton_method 'search_by' do |opts|
  joins(:custom_attributes)
    .where(company: opts[:company])
    .where('custom_attributes.field_name = ? and custom_attributes.field_value = ?', opts[:field_name], opts[:field_value])
end
```

here we defined a class method called `search_by` that receives a hash and joins
`custom_attributes` table in order to search for users from an specific company
that matches the criteria (`field_name` and `field_value`)

the next block is where how we save it:

```ruby
define_method 'configure_attribute' do |attribute, new_value|
  attribute_registered?(attribute)
  custom_attribute = custom_attributes.find_or_create_by(company: company, field_name: attribute)
  custom_attribute.update(field_value: new_value)
end
```

The method `configure_attribute` receives two parameters: `attribute` and
`new_value`. The first thing we check is if the attribute is allowed in the
`Company` through `attribute_registered?` method that will raise an exception in
case this attribute is not allowed. Then we use `find_or_create_by` scoping to
the company and field name to avoid data duplication in the database.  

I've also added an unique index to `custom_attributes` on `company_id`, `user_id` and
`field_name` so we make sure that there are no duplicates and are safe to scale
it for faster queries.

### Dependencies

- Ruby 2.5.1  
- SQLite 3

### Installing

```shell
bundle install
```

### Running the tests

```shell
RAILS_ENV=test rails db:create db:migrate
bundle exec rspec
```
