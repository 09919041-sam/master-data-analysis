/*
TASK 1a - PROGETTAZIONE CONCETTUALE

Domanda:
Individuare le entità dello scenario ToysGroup e le relazioni
tra loro in uno schema Entità/Relazione.

ENTITA' PRODUCT
Chiave: ProductID
Attributi descrittivi: ProductName, Category

ENTITA' REGION
Chiave: RegionID
Attributi descrittivi: State, SalesRegion

ENTITA' SALES
Chiave: SalesID
Attributi: ProductID, RegionID, SalesDate, Quantity, SalesAmount

RELAZIONI:
Product - Sales = 1:N
Region - Sales = 1:N

GERARCHIE:
Product include Category.
Region include State.
*/
/*
TASK 1b - PROGETTAZIONE LOGICA

Domanda:
Tradurre lo schema concettuale in tabelle relazionali,
indicando colonne, tipi di dato e ruolo PK, FK o attributo.

PRODUCT
ProductID    INT             PK
ProductName  VARCHAR(100)    Attributo
Category     VARCHAR(50)     Attributo

REGION
RegionID     INT             PK
State        VARCHAR(50)     Attributo
SalesRegion  VARCHAR(50)     Attributo

SALES
SalesID      INT             PK
ProductID    INT             FK -> Product(ProductID)
RegionID     INT             FK -> Region(RegionID)
SalesDate    DATE            Attributo
Quantity     INT             Attributo
SalesAmount  DECIMAL(10,2)   Attributo
*/
/*
TASK 2 - DDL: CREAZIONE DELLE TABELLE

Domanda:
Descrivere la struttura delle tabelle utili a modellare
lo scenario ToysGroup tramite sintassi DDL e implementarle
fisicamente in MySQL.
*/

CREATE DATABASE ToysGroup;
USE ToysGroup;
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL
);
DESCRIBE Product;
CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    State VARCHAR(50) NOT NULL,
    SalesRegion VARCHAR(50) NOT NULL
);
DESCRIBE Region;
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    RegionID INT NOT NULL,
    SalesDate DATE NOT NULL,
    Quantity INT NOT NULL,
    SalesAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

/*
TASK 3 - POPOLAMENTO DATI

Domanda:
Popolare le tabelle con dati a scelta:
- almeno 4 prodotti distribuiti su almeno 2 categorie;
- almeno 3 stati distribuiti su almeno 2 regioni di vendita;
- almeno 10 transazioni distribuite su più anni.
*/
INSERT INTO Product (ProductID, ProductName, Category)
VALUES
(1, 'Bikes-100', 'Bikes'),
(2, 'Bikes-200', 'Bikes'),
(3, 'Doll-100', 'Dolls'),
(4, 'Doll-200', 'Dolls'),
(5, 'Game-100', 'Games');

INSERT INTO Region (RegionID, State, SalesRegion)
VALUES
(1, 'France', 'WestEurope'),
(2, 'Germany', 'WestEurope'),
(3, 'Italy', 'SouthEurope');
SELECT * FROM Region;
INSERT INTO Sales
    (SalesID, ProductID, RegionID, SalesDate, Quantity, SalesAmount)
VALUES
(1, 1, 1, '2024-02-15', 3, 450.00),
(2, 2, 2, '2024-05-20', 2, 500.00),
(3, 3, 3, '2024-09-10', 5, 250.00),
(4, 4, 1, '2024-11-25', 4, 320.00),
(5, 1, 2, '2025-01-18', 5, 750.00),
(6, 2, 3, '2025-04-12', 3, 750.00),
(7, 3, 1, '2025-07-08', 8, 400.00),
(8, 4, 2, '2025-10-21', 6, 480.00),
(9, 1, 3, '2026-02-14', 10, 1500.00),
(10, 2, 1, '2026-04-30', 4, 1000.00),
(11, 3, 2, '2026-06-16', 7, 350.00),
(12, 4, 3, '2026-08-05', 3, 240.00);
SELECT * FROM Sales;
/*
TASK 4a - INTEGRITA' E JOIN
Domanda:
Verificare l'unicita' delle chiavi primarie e costruire
l'elenco delle transazioni tramite INNER JOIN.
*/

/* Verifica unicita' chiave primaria Product */
SELECT ProductID, COUNT(*) AS Occorrenze
FROM Product
GROUP BY ProductID
HAVING COUNT(*) > 1;

/* Verifica unicita' chiave primaria Region */
SELECT RegionID, COUNT(*) AS Occorrenze
FROM Region
GROUP BY RegionID
HAVING COUNT(*) > 1;

/* Verifica unicita' chiave primaria Sales */
SELECT SalesID, COUNT(*) AS Occorrenze
FROM Sales
GROUP BY SalesID
HAVING COUNT(*) > 1;

/* INNER JOIN tra Sales, Product e Region */
SELECT
    p.ProductID,
    p.Category,
    r.State,
    r.SalesRegion,
    s.SalesDate
FROM Sales AS s
INNER JOIN Product AS p
    ON s.ProductID = p.ProductID
INNER JOIN Region AS r
    ON s.RegionID = r.RegionID;
    SELECT COUNT(*) AS NumeroTransazioni
FROM Sales;
SELECT COUNT(*) AS NumeroTransazioniJoin
FROM Sales AS s
INNER JOIN Product AS p
    ON s.ProductID = p.ProductID
INNER JOIN Region AS r
    ON s.RegionID = r.RegionID;
SELECT
    p.ProductID,
    p.Category,
    r.State,
    r.SalesRegion,
    s.SalesDate,
    CASE
        WHEN DATEDIFF(CURDATE(), s.SalesDate) > 180 THEN TRUE
        ELSE FALSE
    END AS Over180Days
FROM Sales AS s
INNER JOIN Product AS p
    ON s.ProductID = p.ProductID
INNER JOIN Region AS r
    ON s.RegionID = r.RegionID;
    /*

TASK 4b - AGGREGAZIONI E RAGGRUPPAMENTI
Domanda:
Calcolare il fatturato aggregato per diverse chiavi di analisi
utilizzando GROUP BY e le funzioni di aggregazione.
*/
SELECT
    ProductID,
    YEAR(SalesDate) AS Anno,
    SUM(SalesAmount) AS FatturatoTotale
FROM Sales
GROUP BY ProductID, YEAR(SalesDate);
SELECT
    r.State,
    YEAR(s.SalesDate) AS Anno,
    SUM(s.SalesAmount) AS FatturatoTotale
FROM Sales AS s
INNER JOIN Region AS r
    ON s.RegionID = r.RegionID
GROUP BY r.State, YEAR(s.SalesDate)
ORDER BY Anno ASC, FatturatoTotale DESC;
SELECT
    p.Category,
    SUM(s.Quantity) AS QuantitaTotale
FROM Sales AS s
INNER JOIN Product AS p
    ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY QuantitaTotale DESC
LIMIT 1;
/*
TASK 4c - SUBQUERY E CTE
Domanda:
Esporre i prodotti venduti con quantità totale superiore
alla media di vendita dell'ultimo anno censito,
prima mediante subquery e poi mediante CTE.

Le due soluzioni devono restituire lo stesso risultato.
*/
SELECT MAX(YEAR(SalesDate)) AS UltimoAnnoCensito
FROM Sales;
SELECT
    ProductID,
    SUM(Quantity) AS TotaleVenduto
FROM Sales
WHERE YEAR(SalesDate) = (
    SELECT MAX(YEAR(SalesDate))
    FROM Sales
)
GROUP BY ProductID;
SELECT
    TotaliProdotto.ProductID,
    TotaliProdotto.TotaleVenduto
FROM (
    SELECT
        ProductID,
        SUM(Quantity) AS TotaleVenduto
    FROM Sales
    WHERE YEAR(SalesDate) = (
        SELECT MAX(YEAR(SalesDate))
        FROM Sales
    )
    GROUP BY ProductID
) AS TotaliProdotto
WHERE TotaliProdotto.TotaleVenduto > (
    SELECT AVG(TotaleVenduto)
    FROM (
        SELECT
            ProductID,
            SUM(Quantity) AS TotaleVenduto
        FROM Sales
        WHERE YEAR(SalesDate) = (
            SELECT MAX(YEAR(SalesDate))
            FROM Sales
        )
        GROUP BY ProductID
    ) AS MediaProdotti
);
WITH TotaliProdotto AS (
    SELECT
        ProductID,
        SUM(Quantity) AS TotaleVenduto
    FROM Sales
    WHERE YEAR(SalesDate) = (
        SELECT MAX(YEAR(SalesDate))
        FROM Sales
    )
    GROUP BY ProductID
),
MediaVendite AS (
    SELECT AVG(TotaleVenduto) AS MediaQuantita
    FROM TotaliProdotto
)
SELECT
    TotaliProdotto.ProductID,
    TotaliProdotto.TotaleVenduto
FROM TotaliProdotto
CROSS JOIN MediaVendite
WHERE TotaliProdotto.TotaleVenduto > MediaVendite.MediaQuantita;
/*
TASK 4d - WINDOW FUNCTIONS
Domanda:
Arricchire il result set delle transazioni con una classifica,
un totale progressivo e il confronto con la transazione
precedente, utilizzando funzioni finestra.
*/
WITH FatturatoProdotto AS (
    SELECT
        p.ProductID,
        p.Category,
        SUM(s.SalesAmount) AS FatturatoTotale
    FROM Product AS p
    INNER JOIN Sales AS s
        ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.Category
)
SELECT
    ProductID,
    Category,
    FatturatoTotale,
    RANK() OVER (
        PARTITION BY Category
        ORDER BY FatturatoTotale DESC
    ) AS PosizioneClassifica
FROM FatturatoProdotto;
SELECT
    SalesID,
    RegionID,
    SalesDate,
    SalesAmount,
    SUM(SalesAmount) OVER (
        PARTITION BY RegionID
        ORDER BY SalesDate, SalesID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS FatturatoProgressivo
FROM Sales
ORDER BY RegionID, SalesDate, SalesID;
SELECT
    SalesID,
    RegionID,
    SalesDate,
    SalesAmount,
    LAG(SalesAmount) OVER (
        PARTITION BY RegionID
        ORDER BY SalesDate, SalesID
    ) AS FatturatoPrecedente
FROM Sales
ORDER BY RegionID, SalesDate, SalesID;
SELECT
    SalesID,
    RegionID,
    SalesDate,
    SalesAmount,
    LAG(SalesAmount) OVER (
        PARTITION BY RegionID
        ORDER BY SalesDate, SalesID
    ) AS FatturatoPrecedente,
    SalesAmount - LAG(SalesAmount) OVER (
        PARTITION BY RegionID
        ORDER BY SalesDate, SalesID
    ) AS DifferenzaFatturato
FROM Sales
ORDER BY RegionID, SalesDate, SalesID;
/*
TASK 4e - PRODOTTI INVENDUTI E VIEW
Domanda:
Individuare i prodotti mai venduti utilizzando due approcci
differenti e creare due viste riutilizzabili per il reporting.
*/
SELECT
    p.ProductID,
    p.ProductName
FROM Product AS p
LEFT JOIN Sales AS s
    ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL;
SELECT
    p.ProductID,
    p.ProductName
FROM Product AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales AS s
    WHERE s.ProductID = p.ProductID
);
CREATE VIEW vw_Product AS
SELECT
    ProductID,
    ProductName,
    Category
FROM Product;
SELECT * FROM vw_Product;
CREATE VIEW vw_Geography AS
SELECT
    RegionID,
    State,
    SalesRegion
FROM Region;
SELECT * FROM vw_Geography;
/*
GOVERNANCE & PRIVACY - CASO 1
Problema:
La vista PublicProductView espone PurchaseCost.
Il costo di acquisto rappresenta un'informazione commerciale
interna e non e' necessario per una vista pubblica.

Correzione:
Applicare il principio di minimizzazione dei dati,
esponendo esclusivamente le informazioni necessarie.
*/

CREATE VIEW PublicProductView AS
SELECT
    ProductID,
    ProductName,
    Category
FROM Product;
/*
=========================================================
GOVERNANCE & PRIVACY
=========================================================

Obiettivo:
Analizzare le strutture proposte, individuare eventuali
criticita' di governance/privacy e proporre una correzione.
*/


/*
CASO 1 - Vista pubblica dei prodotti

Struttura proposta:
CREATE VIEW PublicProductView AS
SELECT ProductID, ProductName, Category, PurchaseCost
FROM Product;

Problema:
La vista pubblica espone PurchaseCost, un'informazione
commerciale interna che non e' necessaria per la finalita'
della vista.

Correzione:
Applicare il principio di minimizzazione dei dati ed esporre
soltanto le informazioni necessarie.

Soluzione proposta:
CREATE VIEW PublicProductView AS
SELECT ProductID, ProductName, Category
FROM Product;
*/


/*
CASO 2 - Contatti dei fornitori

Struttura proposta:
CREATE TABLE SupplierContact (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactPhone VARCHAR(20)
);

La tabella viene condivisa con il reparto Marketing.

Problema:
Il numero di telefono del contatto viene reso disponibile
anche a utenti che potrebbero non averne necessita'.

Correzione:
Applicare i principi di minimizzazione dei dati e del minimo
privilegio, limitando l'accesso ai dati di contatto ai soli
utenti o reparti che ne necessitano per la propria attivita'.

Una possibile vista destinata al Marketing potrebbe esporre
soltanto:
CREATE VIEW MarketingSupplierView AS
SELECT SupplierID, SupplierName
FROM SupplierContact;
*/


/*
CASO 3 - Vista commerciale

Struttura proposta:
CREATE VIEW CommercialView AS
SELECT
    SalesID,
    ProductID,
    SalesAmount,
    PurchaseCost,
    Margin
FROM Sales;

Problema:
La vista espone PurchaseCost e Margin, informazioni economiche
interne che potrebbero non essere necessarie a tutti gli utenti
che consultano i dati commerciali.

Correzione:
Limitare le colonne esposte in base alle effettive necessita'
del destinatario della vista e applicare il principio del
minimo privilegio.

Una possibile versione con le sole informazioni di vendita e':

CREATE VIEW CommercialView AS
SELECT SalesID, ProductID, SalesAmount
FROM Sales;
*/


/*
CASO 4 - Log degli accessi

Struttura proposta:
CREATE TABLE ReportAccessLog (
    UserID INT,
    QueryText TEXT,
    AccessDate DATETIME
);

Problema:
I dati vengono conservati senza una scadenza definita.
Una conservazione indefinita non rispetta il principio
di limitazione della conservazione.

Correzione:
Definire una retention policy con un periodo di conservazione
coerente con le finalita' di sicurezza, audit e conformita'.
Alla scadenza prevista i dati devono essere cancellati
o, se appropriato, anonimizzati.
*/
SHOW TABLES;

