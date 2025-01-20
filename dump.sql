DROP TABLE IF EXISTS composant_electrique CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS projet CASCADE;
DROP TABLE IF EXISTS personnel CASCADE;
DROP TABLE IF EXISTS magasin CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;
DROP TABLE IF EXISTS contient CASCADE;
DROP TABLE IF EXISTS compose CASCADE;
DROP TABLE IF EXISTS travaille CASCADE;
DROP TABLE IF EXISTS propose CASCADE;


CREATE TABLE composant_electrique (
    libelle varchar(20) PRIMARY KEY,
    nom_composant varchar(30) NOT NULL UNIQUE,
    description text,
    marque varchar(30)
);

CREATE TABLE client (
    num_client serial PRIMARY KEY,
    nom_client varchar(50) NOT NULL,
    prenom_client varchar(50) NOT NULL,
    adresse_email_client varchar(50) UNIQUE
);

CREATE TABLE projet (
    id_projet serial PRIMARY KEY,
    nom_projet varchar(40) NOT NULL,
    num_client int REFERENCES client(num_client)
    ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE personnel (
    id_personnel serial PRIMARY KEY,
    nom_personnel varchar(50) NOT NULL,
    prenom_personnel varchar(50) NOT NULL,
    mot_de_passe     varchar(50) NOT NULL
);

CREATE TABLE magasin (
    num_magasin serial PRIMARY KEY,
    adresse_magasin varchar(50),
    nom_magasin varchar(20) NOT NULL,
    num_telephone_magasin varchar(50) UNIQUE,
    gerant int REFERENCES personnel(id_personnel)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE transaction (
    id_transaction serial PRIMARY KEY,
    date_transaction date,
    num_client int REFERENCES client(num_client) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    num_magasin int REFERENCES magasin(num_magasin) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    id_personnel int REFERENCES personnel(id_personnel) 
    ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE contient(
    id_projet serial references projet(id_projet)
    ON DELETE CASCADE ON UPDATE CASCADE,
    libelle varchar(20) references  composant_electrique(libelle)
    ON DELETE SET NULL ON UPDATE CASCADE,
    nb_composants int,
    primary key(id_projet, libelle)
);


CREATE TABLE compose (
    libelle varchar(20) references  composant_electrique(libelle)
    ON DELETE CASCADE ON UPDATE CASCADE,
    id_transaction serial references transaction(id_transaction)
    ON DELETE CASCADE ON UPDATE CASCADE,
    quantite_produit int,
    prix_unitaire_initial real,
    primary key (libelle, id_transaction)
);



CREATE TABLE travaille (
    num_magasin serial references  magasin(num_magasin)
    ON DELETE CASCADE ON UPDATE CASCADE,
    id_personnel serial references personnel(id_personnel)
    ON DELETE CASCADE ON UPDATE CASCADE,
    jour date,
    primary key(num_magasin, id_personnel, jour)
);



CREATE TABLE propose(
    libelle varchar(20) references  composant_electrique(libelle)
    ON DELETE CASCADE ON UPDATE CASCADE,
    num_magasin serial references  magasin(num_magasin)
    ON DELETE CASCADE ON UPDATE CASCADE,
    prix_unitaire real,
    primary key (libelle, num_magasin)
);


---Filling table composant_electrique :

INSERT INTO composant_electrique VALUES
('PB00622154','Fox Spirit FG1 (Black)',
'Medium Tower case with tempered glass panel and 3 ARGB 120 mm 
fans on the front', 'Fox Spirit'),
('PB00390708', 'ASRock A520M Phantom Gaming 4', 
'Micro-ATX motherboard Socket AM4 AMD A520 - 4x DDR4 -
 SATA 6Gb/s M.2 PCI-E NVMe - USB 3.0 - 
2x PCI-Express 3.0 16x', 'ASRock');

---Filling table client :

INSERT INTO client(nom_client, prenom_client, adresse_email_client) VALUES 
('Kita', 'Etienne', 'etienne@mail.com'), 
('Gon', 'Freecss', 'Gon@strong.com'), ('Zoldik', 'Killua', 'Zoldyck@assasin.com');

---Filling table projet :

INSERT INTO projet(nom_projet, num_client) VALUES 
('Chimera Ant Desctruction', 2), 
('PC Building', 3);

---Filling table personnel :

INSERT INTO personnel(nom_personnel, prenom_personnel, mot_de_passe) VALUES 
('Freecss', 'Ging', '084fe8aecafea8b2f84'),
 ('Monkey.D', 'Luffy', '084fe8afufa8b2f84');

---Filling table magasin :

INSERT INTO magasin(adresse_magasin, nom_magasin, num_telephone_magasin, gerant) VALUES 
('50 rue Carthage', 'Cabsa', '07877777779', 1), 
('12 rue Byrsa','Byrsa' ,'0656348313', 2);

---Filling table transaction :

INSERT INTO transaction(date_transaction, num_client, num_magasin, id_personnel) VALUES 
('13-03-2022', 1, 1, 1), 
('19-03-1750', 1, 2, 1);

---Filling table contient :

INSERT INTO contient VALUES
(2,'PB00622154' , 1),
(2,'PB00390708' , 2);

---Filling table compose :

INSERT INTO compose VALUES
('PB00390708',1 , 2  , 50.99 ),
('PB00390708', 2, 100, 13.72 );

---Filling table travaille :

INSERT INTO travaille VALUES
(1, 1 , '18-03-1750'),
(1, 1 , '18-03-2022' ),
(1, 1 , '10-01-2025'),
(2, 2 , '10-01-2025');

---Filling table propose :

INSERT INTO propose VALUES
('PB00622154', 1 , 82.95),
('PB00622154', 2 , 89.99 ),
('PB00390708', 1 , 83.60),
('PB00390708', 2 , 80);
