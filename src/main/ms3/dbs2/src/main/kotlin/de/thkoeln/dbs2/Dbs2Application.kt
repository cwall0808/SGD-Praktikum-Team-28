package de.thkoeln.dbs2

import de.thkoeln.dbs2.model.Benutzer
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.CommandLineRunner
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.jdbc.core.BeanPropertyRowMapper
import org.springframework.jdbc.core.JdbcTemplate


@SpringBootApplication
class Dbs2Application : CommandLineRunner {
	@Autowired
	private val jdbcTemplate: JdbcTemplate? = null

	companion object {
		@JvmStatic
		fun main(args: Array<String>) {
			runApplication<Dbs2Application>(*args)
		}
	}

	@Throws(Exception::class)
	override fun run(vararg args: String?) {
		val sql = "SELECT * FROM Benutzer"
		val users: List<Benutzer> =
			jdbcTemplate!!.query(
			sql,
			BeanPropertyRowMapper.newInstance(Benutzer::class.java)
		)
		users.forEach(System.out::println)
	}
}
