:- module(accounting, [
    ledger_entry_term/9,
    balanced_ledger/1
]).

:- use_module(library(lists)).

ledger_entry_term(EntryId, BusinessId, Timestamp, Debit, Credit, Amount, Description, Source, ledger_entry(
    EntryId,
    business(BusinessId),
    timestamp(Timestamp),
    debit(Debit),
    credit(Credit),
    amount(Amount),
    description(Description),
    source(Source)
)).

balanced_ledger(Entries) :-
    findall(Amount, member(ledger_entry(_, _, _, _, _, amount(Amount), _, _), Entries), Amounts),
    sum_list(Amounts, Total),
    Total >= 0.
