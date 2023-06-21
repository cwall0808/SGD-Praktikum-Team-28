package de.thkoeln.dbs2.repository;

import de.thkoeln.dbs2.model.Benutzer
import org.springframework.data.jpa.repository.query.Procedure
import org.springframework.data.repository.CrudRepository


interface BenutzerRepository : CrudRepository<Benutzer, Int> {
    @Procedure(procedureName = "QUERY_ACTIVE_USER")
    fun queryActiveUser(userId: Int, query: String?)
}