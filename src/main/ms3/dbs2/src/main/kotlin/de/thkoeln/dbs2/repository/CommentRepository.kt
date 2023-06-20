package de.thkoeln.dbs2.repository

import de.thkoeln.dbs2.model.Kommentar
import org.springframework.data.repository.CrudRepository

interface CommentRepository : CrudRepository<Kommentar, Int> {
}
