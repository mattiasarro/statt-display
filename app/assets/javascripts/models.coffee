Statt.Site = DS.Model.extend
  do_something: () -> "asdf"

Statt.LoadsPage = DS.Model.extend
  page_nr: DS.attr("number")
  nr_pages: DS.attr("number")
  loads: DS.hasMany("Statt.Load")

Statt.Load = DS.Model.extend
  page: DS.belongsTo("Statt.LoadsPage")