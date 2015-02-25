#/**
# * Initialize a new `Base` reporter.
# *
# * All other reporters generally
# * inherit from this reporter, providing
# * stats such as test duration, number
# * of tests passed / failed etc.
#*
#* @param {Runner} runner
#* @api public
#*/

practical.mocha ?= {}

class practical.mocha.MeteorPublishReporter extends BaseReporter

  # TODO: Change this to use Meteor.bindEnvironment
  @publisher: null

  constructor: (@runner)->
    expect(@runner).to.be.an 'object'
    expect(practical.mocha.MeteorPublishReporter.publisher).to.be.an('object').that.contains.keys(['ready', 'added', 'stop'])
    @sequence = 0

    @runner.emit 'start', (total)=>
      @added 'start', {total: total}
      @publisher.ready()

    @runner.emit 'suite', (suite)=>
      @added 'suite', {suite: suite}

    @runner.emit 'test end', (test)=>
      @added 'test end', {test: test}

    @runner.emit 'pass', (test)=>
      @added 'pass', {test: test}

    @runner.emit 'fail', (test, error)=>
      @added 'fail', {test: test, error: error}

    @runner.on 'end', =>
      @added 'end', {}

    @runner.on 'pending', (test)=>
      @added 'pending', {test: test}

  added: (event, data)->
    doc =
      _id: ++@sequence
      event: event
      data: data
    @publisher.added()
