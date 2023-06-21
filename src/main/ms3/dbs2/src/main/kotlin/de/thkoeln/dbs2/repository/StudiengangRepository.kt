package de.thkoeln.dbs2.repository

import de.thkoeln.dbs2.model.Studiengang
import org.springframework.data.jpa.repository.query.Procedure
import org.springframework.data.repository.CrudRepository

interface StudiengangRepository : CrudRepository<Studiengang, Int> {
    @Procedure("UPDATE_DEGREE_GROUPS")
    fun updateDegreeGroups()
}