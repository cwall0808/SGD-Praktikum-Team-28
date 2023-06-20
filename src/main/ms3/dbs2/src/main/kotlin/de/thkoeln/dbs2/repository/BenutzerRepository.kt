package de.thkoeln.dbs2.repository;

import de.thkoeln.dbs2.model.Benutzer;
import org.springframework.data.repository.CrudRepository;

interface BenutzerRepository : CrudRepository<Benutzer, Int>