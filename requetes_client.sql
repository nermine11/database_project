-- connexion_client
SELECT num_client, nom_client, prenom_client
FROM client
WHERE email_client = :email_client AND mot_de_passe_client = :mot_de_passe_client;

-- inscription_client
INSERT INTO client (nom_client, prenom_client, email_client, mot_de_passe_client)
VALUES (:nom_client, :prenom_client, :email_client, :mot_de_passe_client);

-- search magasin
SELECT num_magasin, nom_magasin, adresse_magasin, num_telephone_magasin
FROM magasin
WHERE nom_magasin LIKE '%' || :nom_magasin || '%';

-- search composant 
SELECT libelle, nom_composant, description, marque
FROM composant_electrique
WHERE nom_composant LIKE '%' || :nom_composant || '%';

-- search composant avec magasin
SELECT libelle, nom_composant, description, marque, prix_unitaire
FROM composant_electrique NATURAL JOIN propose
WHERE num_magasin = :num_magasin AND LIKE '%' || :nom_composant || '%';

-- lowest magasin for composant
SELECT num_magasin, nom_magasin, adresse_magasin, prix_unitaire
FROM magasin NATURAL JOIN propose
WHERE libelle = :libelle
ORDER BY prix_unitaire ASC;

-- Add composant to projet
INSERT INTO contient (id_projet, libelle, nb_composants)
VALUES (:id_projet, :libelle, :nb_composants);

-- Modify composant in projet
UPDATE contient
SET nb_composants = :nb_composants
WHERE id_projet = :id_projet AND libelle = :libelle;

-- Remove composant from projet
DELETE FROM contient
WHERE id_projet = :id_projet AND libelle = :libelle;

-- Create projet
INSERT INTO projet(nom_projet, num_client)
VALUES ('Nouveau projet', :num_client);

-- Renommer projet
UPDATE projet
SET nom_projet = :nom_projet
WHERE id_projet = :id_projet;

-- Suppr projet
DELETE FROM projet
WHERE id_projet = :id_projet;

-- Meilleurs magasins projet par prix
SELECT num_magasin, nom_magasin, adresse_magasin, sum(prix_unitaire*nb_composants) AS prix_total
FROM magasin NATURAL JOIN propose NATURAL JOIN contient
WHERE id_projet = :id_projet
GROUP BY num_magasin
ORDER BY sum(prix_unitaire*nb_composants) ASC;


-- get factures
SELECT id_transaction, date_transaction, nom_client, nom_magasin, adresse_magasin, nom_personnel, prenom_personnel, sum(prix_unitaire_achat*quantite_produit) AS prix_total
FROM transaction NATURAL JOIN client NATURAL JOIN magasin NATURAL JOIN personnel NATURAL JOIN compose
WHERE num_client = :num_client
GROUP BY id_transaction
ORDER BY date_transaction DESC;

-- get facture complete
SELECT libelle, nom_composant, description, marque, quantite_produit, prix_unitaire_achat, prix_unitaire_achat*quantite_produit AS prix_total
FROM composant_electrique NATURAL JOIN compose
WHERE id_transaction = :id_transaction;