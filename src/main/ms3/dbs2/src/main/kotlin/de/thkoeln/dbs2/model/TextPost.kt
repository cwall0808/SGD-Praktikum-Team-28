package de.thkoeln.dbs2.model

import jakarta.persistence.Entity
import jakarta.persistence.Id

@Entity
data class TextPost (
    @Id
    var p_id: Int,
    var inhalt: String
)