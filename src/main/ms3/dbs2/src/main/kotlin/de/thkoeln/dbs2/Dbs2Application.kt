package de.thkoeln.dbs2

import de.thkoeln.dbs2.model.Benutzer
import de.thkoeln.dbs2.model.Studiengang
import de.thkoeln.dbs2.repository.BenutzerRepository
import de.thkoeln.dbs2.repository.StudiengangRepository
import de.thkoeln.dbs2.model.Kommentar
import de.thkoeln.dbs2.model.TextPost
import de.thkoeln.dbs2.repository.CommentRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.CommandLineRunner
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.jdbc.core.BeanPropertyRowMapper
import org.springframework.jdbc.core.JdbcTemplate

@SpringBootApplication
class Dbs2Application : CommandLineRunner {
	@Suppress("SpringJavaInjectionPointsAutowiringInspection")
	@Autowired
	val jdbcTemplate: JdbcTemplate? = null
	@Autowired
	lateinit var userRepository: BenutzerRepository
	@Autowired
	lateinit var degreeRepository: StudiengangRepository
	@Autowired
	lateinit var commentRepository: CommentRepository

	lateinit var currentUser: Benutzer

	@Throws(Exception::class)
	override fun run(vararg args: String?) {
		displayWelcomeScreen()
	}

	fun displayWelcomeScreen(){
		println(" _.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._\n" +
				" ,'_.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._`.")
		println("     ________ __  __ __         __   \n" +
				"    /_  __/ // / / //_/__  ___ / /__ \n" +
				"     / / / _  / / ,< / _ \\/ -_) / _ \\\n" +
				"    /_/ /_//_/ /_/|_|\\___/\\__/_/_//_/")
		println(" _.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._\n" +
				" ,'_.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._`.")
		while(true){
			println("\nWillkommen zu der Social Media Konsolenanwendung der TH Köln!\n")
			println("1.『 Einloggen 』")
			println("2.『 Registrieren 』")
			println("3.『 Anwendung beenden 』\n")

			when(readln()){
				"1" -> {
					displayLoginScreen()
				}
				"2" -> {
					displayRegistrationScreen()
				}
				"3" -> {}
				else -> {
					println("Dies ist keine gültige Eingabe. Bitte antworte entweder mit '1', '2' oder '3'.")
					continue
				}
			}
			return
		}
	}

	fun displayLoginScreen(){
		println("\nBitte logge dich mit deinen Benutzerdaten ein.")
		print("E-Mail:   ")
		val email = readln()
		print("Passwort: ")
		val pw = readln()
		println("Du wirst eingeloggt...")
		Thread.sleep(500)
		login(email, pw)
	}

	fun login(email: String, pw: String){
		val sql = "SELECT * FROM Benutzer WHERE e_mail = '$email' AND passwort = '$pw'" // todo: deny sql injections
		val users: List<Benutzer> =
			jdbcTemplate!!.query(
				sql,
				BeanPropertyRowMapper.newInstance(Benutzer::class.java)
			)
		if (users.isNotEmpty()) {
			currentUser = users.first()
			println("\nWillkommen, ${currentUser.vorname}!")
			displayMainScreen()
		} else {
			displayFailedLoginScreen()
		}
	}

	fun displayMainScreen() {
		while(true){
			println("\nSuche eine Option aus.\n")
			println("1.『 Posts anzeigen 』")
			println("2.『 Programm beenden 』")

			when(readln()){
				"1" -> displayTextPostsScreen()
				"2" -> return
				else -> println("\nDies ist keine gültige Eingabe. Bitte antworte entweder mit '1' oder '2'")
			}
		}
	}

	fun displayFailedLoginScreen(){
		while(true){
			println("\nDieser Benutzer konnte leider nicht gefunden werden! Bitte versuche es erneut.\n")
			println("1.『 Nochmal Einloggen 』")
			println("2.『 Zurück zum Willkommensbildschirm 』")

			when(readln()){
				"1" -> {
					displayLoginScreen()
				}
				"2" -> {
					displayWelcomeScreen()
				}
				else -> {
					println("\nDies ist keine gültige Eingabe. Bitte antworte entweder mit '1' oder '2'")
					continue
				}
			}
			return
		}
	}

	fun displayRegistrationScreen() {
		println("\nBitte log dich mit deinen Benutzerdaten ein.")

		print("Vorname:   ")
		val firstname = readln()
		print("Nachname:   ")
		val lastname = readln()
		print("E-Mail: ")
		val email = readln().trim()
		print("Passwort: ")
		val pw = readln().trim()
		print("Studiengang: ")
		val degree = readln()

		val foundDegree = degreeRepository.findAll().firstOrNull { it.name == degree }

		println("...")
		Thread.sleep(500)
		try {
			if(foundDegree != null){
				register(firstname, lastname, email, pw, foundDegree.s_id)
			} else {
				register(firstname, lastname, email, pw, degreeRepository.save(Studiengang(degree)).s_id)
			}
		} catch (e : Exception){
			if(e.message!!.contains("VALIDATE_PW")){
				println("Das Passwort ist ungültig. Bitte versuche es erneut!")
				displayRegistrationScreen()
			} else {
				println("Diese E-Mail ist ungültig. Bitte versuche es erneut!")
				displayRegistrationScreen()
			}
		}
	}

	fun register(firstname: String, lastname: String, email: String, pw: String, degree: Int){
		userRepository.save(Benutzer(firstname, lastname, email, pw, degree))
		println("\nHallo, $firstname! Dein Account wurde erstellt. Bitte log dich jetzt ein.\n")
		displayLoginScreen()
	}

	fun displayTextPostsScreen() {
		val textPosts = printTextPosts()

		while (true) {
			println("\nSuche einen Post zum Kommentieren aus (n = Hauptbildschirm).")

			when (val input = readln()) {
				"n" -> {}
				else -> {
					val postIndex = input.toIntOrNull()

					if (postIndex == null || postIndex - 1 !in textPosts.indices) {
						println("\nDies ist keine gültige Eingabe.")
						continue
					}

					displayCommentScreen(textPosts[postIndex - 1].p_id)
				}
			}
			return
		}
	}

	fun printTextPosts(): List<TextPost> {
		val postQuery = "SELECT * FROM Text_Post"

		val textPosts: List<TextPost> = jdbcTemplate!!.query(
			postQuery,
			BeanPropertyRowMapper.newInstance(TextPost::class.java)
		)

		textPosts.forEachIndexed { index, textPost ->
			val comments: List<Kommentar> = commentRepository.findAll().filter {
				it.p_id == textPost.p_id
			}

			println("\n${index + 1}. Post: '${textPost.inhalt}'")
			println("Kommentare:")
			comments.forEach { println("'${it.inhalt}'")}
		}

		return textPosts
	}

	fun displayCommentScreen(postId: Int) {
		println("\nSchreibe deinen Kommentar:")
		val comment = readln()

		commentOnPost(comment, postId)
		println("\nKommentar hochgeladen!")
	}

	fun commentOnPost(contentText: String, postId: Int) {
		val comment = Kommentar(currentUser.b_id, postId, contentText)
		commentRepository.save(comment)
	}

	companion object {
		@JvmStatic
		fun main(args: Array<String>) {
			runApplication<Dbs2Application>(*args)
		}
	}
}

