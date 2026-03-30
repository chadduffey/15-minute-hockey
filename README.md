# 15 Minute Hockey

`15 Minute Hockey` is an iPhone app built around a simple promise: show up for 15 minutes a day and get better through consistency.

The first use case is hockey practice. Each day, a user completes one 15-minute session, logs what they worked on, keeps their streak alive, and gets motivated by progress, reminders, and friends.

## Core Idea

The app should make daily practice feel:

- easy to start
- satisfying to complete
- visible over time
- more motivating with friends

Instead of optimizing for long workouts, `15 Minute Hockey` celebrates consistency. The goal is not perfection. The goal is to keep showing up.

## MVP

The first version should focus on one sport, one daily habit, and one strong social loop.

### User flow

1. Choose hockey as your practice track.
2. Get a reminder to complete today's 15 minutes.
3. Start or log a session.
4. Select what you practiced.
5. Mark the session complete.
6. See your streak, weekly progress, and friend activity.

### Practice categories

The initial hockey categories:

- Goal shooting
- Dribbling
- Passing
- Defending
- Stick skills
- Overheads
- Trapping
- Footwork

Users can select one or more categories for each session and optionally add a short note.

## Product Pillars

### 1. Daily habit

The app should reduce friction so a user can log a session in seconds.

Key ideas:

- one main call to action: `Do your 15 minutes`
- simple daily completion state
- reminders that feel supportive, not nagging
- flexible logging so missing exact timing does not break the habit

### 2. Streak motivation

Consistency is the emotional engine of the app.

Key ideas:

- current streak
- longest streak
- weekly completion score out of 7
- milestone celebrations for 3, 7, 14, 30, 50, and 100 days
- gentle recovery language if a streak breaks

### 3. Progress visibility

The app should make improvement feel tangible even before skill gains are obvious.

Key ideas:

- weekly calendar with completed days crossed off
- monthly consistency view
- category breakdown over time
- session history with notes
- personal stats like `You practiced footwork 9 times this month`

### 4. Friendly social pressure

Social features should motivate, not shame.

Key ideas:

- add friends
- see whether friends completed their 15 minutes today
- weekly leaderboard by number of completed days
- streak leaderboard as an alternate view
- reactions like `Nice work` or `On fire`

## Recommended MVP Screens

### Home

The main screen should answer:

- Did I do my 15 minutes today?
- What is my streak?
- What should I do next?

Suggested elements:

- today's completion card
- streak counter
- `Start 15 minutes` button
- category shortcuts
- weekly progress row with 7 day markers
- friend activity preview

### Log Session

Quick and low-friction.

Suggested elements:

- selected date
- 15-minute completion toggle
- category multi-select
- optional notes
- save button

### Progress

A simple stats and history area.

Suggested elements:

- current streak
- longest streak
- weekly and monthly completion charts
- category frequency
- recent sessions list

### Friends

Motivation through visibility.

Suggested elements:

- today's friend status
- weekly leaderboard
- pending friend invites
- simple reactions or encouragement

### Celebrations

This can begin as lightweight modal moments.

Examples:

- `7-day streak`
- `Perfect week`
- `You completed all 7 days this week`

## Notifications

Notifications matter because the app wins or loses on daily return behavior.

Recommended notification types:

- daily reminder at user-selected time
- evening nudge if no session is logged
- celebration after milestone streaks
- social nudge like `Sam completed their 15 today`

The tone should be encouraging and clean:

- `Your 15 minutes is waiting`
- `Keep the streak alive today`
- `One short session. Still counts.`

## Data Model

### User

- id
- name
- profile image
- reminder time
- current streak
- longest streak

### Session

- id
- user id
- date
- completed
- duration minutes
- categories
- note
- created at

### Friendship

- id
- requester id
- addressee id
- status

### Reaction

- id
- from user id
- to user id
- session id
- type

## Success Metrics

The first version should optimize for:

- daily active users
- 7-day retention
- average completed days per week
- percentage of users with a 7+ day streak
- percentage of users with at least 1 friend

## Product Risks

### Logging feels like homework

If logging takes too long, people will skip it.

Response:

- keep session logging under 10 seconds
- default to one-tap completion
- make notes optional

### Social features create pressure

If the app feels judgmental, users may disengage.

Response:

- default to positive language
- compare based on consistency, not skill
- avoid public shaming for missed days

### Streak loss feels punishing

Breaking a streak can cause drop-off.

Response:

- celebrate total sessions too
- show recovery messaging
- consider one grace day per month in a later version

## Suggested V1 Scope

Ship these first:

- sign in / profile
- daily reminder
- create and complete a daily session
- category tagging
- streak tracking
- weekly progress UI
- add friends
- simple friend leaderboard

Wait until later:

- comments
- rich media uploads
- team challenges
- Apple Watch support
- coach mode
- AI-generated drills

## Visual Direction

The app should feel energetic, sporty, and rewarding.

Suggested design cues:

- bold typography
- high-contrast progress states
- bright accent color for completed days
- satisfying streak animations
- clear checkmarks and crossed-off daily progress

The emotional tone should be:

- disciplined
- positive
- competitive in a healthy way
- focused on momentum

## Build Recommendation

For the first implementation:

- use SwiftUI
- use local persistence first for fast iteration
- add Firebase or Supabase once social features need backend sync

Recommended rollout:

1. Single-player local MVP
2. Accounts and cloud sync
3. Friends and leaderboard
4. Smarter reminders and richer stats

## Sharpest Positioning

This is not a generic workout tracker.

`15 Minute Hockey` is a streak-based daily practice app for skill building. It is for people who want to improve by practicing a little every day, with just enough structure and social accountability to stay consistent.
