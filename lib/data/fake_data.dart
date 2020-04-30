const String fakeUsers =
    '[{"id": 1, "name": "paul", '
    '"locations": '
    '['
    '{"id": 1, "name":"GARA_MARKET", "fiscalCode": 8017008.09, "debit":"3171"}, '
    '{"id": 2, "name":"PACO_DEPOZIT", "fiscalCode": 8017008.10, "debit":"3171"}, '
    '{"id": 3, "name":"BAHNE_MARKET", "fiscalCode": 8017008.05, "debit":"3171"}, '
    '{"id": 4, "name":"CETRAL_MARKET", "fiscalCode": 8017008.06, "debit":"3171"}, '
    '{"id": 5, "name":"STEJARI2_MARKET", "fiscalCode": 8017008.08, "debit":"3171"}, '
    '{"id": 6, "name":"SUD_MARKET", "fiscalCode": 8017008.07, "debit":"3171"}, '
    '{"id": 7, "name":"UNIRII_MARKET", "fiscalCode": 8017008.03, "debit":"3171"}, '
    '{"id": 12, "name":"CUZA_MARKET", "fiscalCode": 8017008.11, "debit":"3171"}, '
    '{"id": 13, "name":"VIDRA_MARKET", "fiscalCode": 8017008.13, "debit":"3171"}, '
    '{"id": 14, "name":"JARISTEA_MARKET", "fiscalCode": 8017008.12, "debit":"3171"} '
    ']},'
    '{"id": 1, "name": "tinel", '
    '"locations": '
    '[{"id": 1, "name":"PETRESTI_MARKET", "fiscalCode": 8017008.17, "debit":"3171"}]}]';

const String products = '['
    '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "price":2.99, "measureUnit":"BUC"},'
    '{"code": 9002859037566, "name":"PRALINE CIOC.ASORTATA 180G MF", "price":5.99, "measureUnit":"BUC"},'
    '{"code": 1, "name":"PORTOCALE", "price":3.49, "measureUnit":"KG"},'
    '{"code": 12345670, "name":"PATE DE FICAT DELISAN 150g", "price":0.99, "measureUnit":"BUC"}'
    ']';

const String stockAtDate = '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "stock":105.00, "stockDate":"2020-04-16", "measureUnit":"BUC"}';

const String lastInputDate = '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "lastInputDate":"2020-04-14"}';

const String salesBetweenDates = '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "sales":58.00, "startIntervalStockDate":"2020-03-01", "endIntervalStockDate":"2020-03-31", "measureUnit":"BUC"}';