package de.thkoeln.dbs2.model

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id

@Entity
class Studiengang (
    var name: String
){
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var s_id: Int = 0
}