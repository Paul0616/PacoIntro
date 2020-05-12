const String fakeUsers =
    '[{"id": 1, "name": "paul", '
    '"locations": '
    '['
    '{"id": 1, "name":"GARA_MARKET", "fiscalCode": 8017008.09, "debit":"3719"}, '
    '{"id": 2, "name":"PACO_DEPOZIT", "fiscalCode": 8017008.10, "debit":"37110"}, '
    '{"id": 3, "name":"BAHNE_MARKET", "fiscalCode": 8017008.05, "debit":"3715"}, '
    '{"id": 4, "name":"CETRAL_MARKET", "fiscalCode": 8017008.06, "debit":"3716"}, '
    '{"id": 5, "name":"STEJARI2_MARKET", "fiscalCode": 8017008.08, "debit":"3718"}, '
    '{"id": 6, "name":"SUD_MARKET", "fiscalCode": 8017008.07, "debit":"3717"}, '
    '{"id": 7, "name":"UNIRII_MARKET", "fiscalCode": 8017008.03, "debit":"3713"}, '
    '{"id": 8, "name":"PACO_MARKET", "fiscalCode": 8017008.99, "debit":"3710"}, '
    '{"id": 12, "name":"CUZA_MARKET", "fiscalCode": 8017008.11, "debit":"37111"}, '
    '{"id": 13, "name":"VIDRA_MARKET", "fiscalCode": 8017008.13, "debit":"37113"}, '
    '{"id": 14, "name":"JARISTEA_MARKET", "fiscalCode": 8017008.12, "debit":"37112"} '
    ']},'
    '{"id": 1, "name": "tinel", '
    '"locations": '
    '[{"id": 1, "name":"PETRESTI_MARKET", "fiscalCode": 8017008.17, "debit":"37117"}]}]';

const String products = '['
    '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "price":2.99, "measureUnit":"BUC"},'
    '{"code": 9002859037566, "name":"PRALINE CIOC.ASORTATA 180G MF", "price":5.99, "measureUnit":"BUC"},'
    '{"code": 1, "name":"PORTOCALE", "price":3.49, "measureUnit":"KG"},'
    '{"code": 12345670, "name":"PATE DE FICAT DELISAN 150g", "price":0.99, "measureUnit":"BUC"}'
    ']';

const String stockAtDate = '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "stock":105.00, "stockDate":"2020-04-16", "measureUnit":"BUC"}';

const String lastInputDate = '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "lastInputDate":"2020-04-14"}';

const String salesBetweenDates = '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "sales":58.00, "startIntervalStockDate":"2020-03-01", "endIntervalStockDate":"2020-03-31", "measureUnit":"BUC"}';

const String order = '{"id":28707, "orderNumber":11123, "orderDate": "4/16/2020 1:33:32 PM", "supplierFiscalCode": 11885854.2, "supplierName": "PROGRES DISTRIBUTIE SRL - BAUTURI"}';

const String orderItems = '['
    '{"code": 5942016300611, "name":"BERE STEJAR DOZA 0.5L", "quantity":24, "measureUnit":"BUC"},'
    '{"code": 5942016302349, "name":"BERE URSUS 0.33L", "quantity":40, "measureUnit":"BUC"},'
    '{"code": 5942016301403, "name":"BERE URSUS 1L", "quantity":36, "measureUnit":"BUC"},'
    '{"code": 5942016300017, "name":"BERE URSUS PREMIUM 0.5L DOZA", "quantity":24, "measureUnit":"BUC"},'
    '{"code": 5942016302349, "name":"CIUCAS 1L", "quantity":36, "measureUnit":"BUC"},'
    '{"code": 5942218001217, "name":"SANTAL CIRESE 1L", "quantity":6, "measureUnit":"BUC"},'
    '{"code": 5942218001132, "name":"SANTAL PORTOCALE ROSII 1L", "quantity":6, "measureUnit":"BUC"},'
    '{"code": 5942218002894, "name":"SANTAL PORTOCALE ROSII 2L", "quantity":6, "measureUnit":"BUC"},'
    '{"code": 5942218003655, "name":"SANTAL VISINE 2L", "quantity":6, "measureUnit":"BUC"},'
    '{"code": 5942016303292, "name":"TIMISOREANA 0.33 L", "quantity":20, "measureUnit":"BUC"},'
    '{"code": 5942016301557, "name":"TIMISOREANA 2.5L PET", "quantity":60, "measureUnit":"BUC"},'
    '{"code": 5942016300260, "name":"TIMISOREANA NEPASTEORIZATA  500ML DOZA", "quantity":24, "measureUnit":"BUC"},'
    '{"code": 5942016302677, "name":"URSUS 0.750ML STICLA", "quantity":12, "measureUnit":"BUC"},'
    '{"code": 5942016303605, "name":"URSUS COOLER F.A. RED ORANGE DOZA 500ML", "quantity":24, "measureUnit":"BUC"},'
    '{"code": 5942016301366, "name":"URSUS DOZE BLACK 500ML", "quantity":24, "measureUnit":"BUC"},'
    '{"code": 5942016303544, "name":"URSUS RETRO DOZA 500ML", "quantity":24, "measureUnit":"BUC"},'
    ']';