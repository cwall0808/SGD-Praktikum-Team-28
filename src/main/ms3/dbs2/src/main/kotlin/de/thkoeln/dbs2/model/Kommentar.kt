package de.thkoeln.dbs2.model

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id

@Entity
data class Kommentar(
    var b_id: Int,
    var p_id: Int,
    var inhalt: String
) {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var k_id: Int = 0
}
