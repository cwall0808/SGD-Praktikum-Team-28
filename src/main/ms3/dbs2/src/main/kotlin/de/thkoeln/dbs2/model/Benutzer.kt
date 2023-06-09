package de.thkoeln.dbs2.model

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id


@Entity
class Benutzer(var vorname: String,
               var nachname: String,
               var e_mail: String,
               var passwort: String,
               var s_id: Int) {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var b_id: Int = 0
}