package de.thkoeln.dbs2.model

import jakarta.persistence.Entity
import jakarta.persistence.Id

@Entity
data class Benutzer (
    @Id
    var id: Int,
    var nachname: String,
    var vorname: String,
    var profilbild_url: String?,
    var beschreibung: String?,
    var e_mail: String,
    var passwort: String,
    var s_id: Int
)