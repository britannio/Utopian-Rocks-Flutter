class SteemResponse {
  final String lastVoteTime;
  final int votingPower;

  SteemResponse(this.lastVoteTime, this.votingPower);

  SteemResponse.fromJson(Map json)
      : this.lastVoteTime = json['last_vote_time'],
        this.votingPower = json['voting_power'];
}