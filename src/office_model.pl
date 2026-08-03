:- module(office_model, [
    create_office_term/4
]).

create_office_term(OfficeId, BusinessId, office_spec(Fields), office(OfficeId, BusinessId, office_spec(Fields))).
