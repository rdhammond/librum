module.exports = (grunt) ->

	grunt.initConfig
		watch:
			sass:
				files: ['sass/**/*.scss']
				tasks: ['sass', 'cssmin']
			javascript:
				files: ['javascript/**/*.js']
				tasks: ['uglify']
			images:
				files: ['images/**/*']
				tasks: ['imagemin']
		clean:
			dist: [
				'public/js'
				'public/css'
				'public/img'
			]
		sass:
			options:
				sourceMap: true
			dist:
				files:
					'public/css/styles.css': 'sass/styles.scss'
		cssmin:
			dist:
				files: [{
					expand: true
					cwd: 'public/css'
					src: ['*.css', '!*.min.css']
					dest: 'public/css'
					ext: '.min.css'
				}]
		uglify:
			dist:
				options:
					sourceMap: yes
				files: [{
					expand: yes
					cwd: 'javascript'
					src: '**/*.js'
					dest: 'public/js'
					rename: (dst, src) ->
						src = src.replace '.js', '.min.js'
						"#{dst}/#{src}"
				}]
		imagemin:
			dist:
				files: [{
					expand: true
					cwd: 'images/'
					src: ['**/*.{png,jpg,gif}']
					dest: 'public/img/'
				}]

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-sass'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-imagemin'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.registerTask 'default', ['clean', 'sass', 'cssmin', 'uglify', 'imagemin']
