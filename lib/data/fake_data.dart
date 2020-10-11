const String fakeUser1 = '{"ID": 1, "NUME UTILIZATOR": "paul", '
    '"LOCATII": '
    '['
    '{"ID": 1, "NUME GESTIUNE":"GARA_MARKET", "COD FISCAL": 8017008.09, "DEBIT":"3719"}, '
    '{"ID": 2, "NUME GESTIUNE":"PACO_DEPOZIT", "COD FISCAL": 8017008.10, "DEBIT":"37110"}, '
    '{"ID": 3, "NUME GESTIUNE":"BAHNE_MARKET", "COD FISCAL": 8017008.05, "DEBIT":"3715"}, '
    '{"ID": 4, "NUME GESTIUNE":"CETRAL_MARKET", "COD FISCAL": 8017008.06, "DEBIT":"3716"}, '
    '{"ID": 5, "NUME GESTIUNE":"STEJARI2_MARKET", "COD FISCAL": 8017008.08, "DEBIT":"3718"}, '
    '{"ID": 6, "NUME GESTIUNE":"SUD_MARKET", "COD FISCAL": 8017008.07, "DEBIT":"3717"}, '
    '{"ID": 7, "NUME GESTIUNE":"UNIRII_MARKET", "COD FISCAL": 8017008.03, "DEBIT":"3713"}, '
    '{"ID": 8, "NUME GESTIUNE":"PACO_MARKET", "COD FISCAL": 8017008.99, "DEBIT":"3710"}, '
    '{"ID": 12, "NUME GESTIUNE":"CUZA_MARKET", "COD FISCAL": 8017008.11, "DEBIT":"37111"}, '
    '{"ID": 13, "NUME GESTIUNE":"VIDRA_MARKET", "COD FISCAL": 8017008.13, "DEBIT":"37113"}, '
    '{"ID": 14, "NUME GESTIUNE":"JARISTEA_MARKET", "COD FISCAL": 8017008.12, "DEBIT":"37112"} '
    ']}';
const String fakeUser2 = '{"ID": 1, "NUME UTILIZATOR": "tinel", '
    '"LOCATII": '
    '[{"ID": 1, "NUME GESTIUNE":"PETRESTI_MARKET", "COD FISCAL": 8017008.17, "DEBIT":"37117"}]}';

const String products =
    '{"current_page":1, "last_page": 1, "next_page_url": null, "data":['
    '{"COD": 5942326400131, "DENUMIRE":"APA CARPATICA PLATA 2L", "PRET":2.99, "UM":"BUC"},'
    '{"COD": 9002859037566, "DENUMIRE":"PRALINE CIOC.ASORTATA 180G MF", "PRET":5.99, "UM":"BUC"},'
    '{"COD": 1, "DENUMIRE":"PORTOCALE", "PRET":3.49, "UM":"KG"},'
    '{"COD": 12345670, "DENUMIRE":"PATE DE FICAT DELISAN 150g", "PRET":0.99, "UM":"BUC"}'
    ']}';

const String stockAtDate =
    '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "stock":105.00, "stockDate":"2020-04-16", "measureUnit":"BUC"}';

const String lastInputDate =
    '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "lastInputDate":"2020-04-14"}';

const String salesBetweenDates =
    '{"code": 5942326400131, "name":"APA CARPATICA PLATA 2L", "sales":58.00, "startIntervalStockDate":"2020-03-01", "endIntervalStockDate":"2020-03-31", "measureUnit":"BUC"}';

const String order =
    '{"id":28707, "orderNumber":11123, "orderDate": "4/16/2020 1:33:32 PM", "supplierFiscalCode": 11885854.2, "supplierName": "PROGRES DISTRIBUTIE SRL - BAUTURI"}';

const String orderItems = '['
    '{"code": 5942016300611, "name":"BERE STEJAR DOZA 0.5L", "quantity":24, "measureUnit":"BUC"},'
    '{"code": 5942016001112, "name":"BERE URSUS 0.33L", "quantity":40, "measureUnit":"BUC"},'
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
    '{"code": 5942016303544, "name":"URSUS RETRO DOZA 500ML", "quantity":24, "measureUnit":"BUC"}'
    ']';
