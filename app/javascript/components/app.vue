<template>
  <div id='app'>
    <div class="row mt mb">
      <search v-on:search="search" />
    </div>
    <div class="row mt mb" v-if="lastSearchesList.length > 0">
      <h5>Previous searches:</h5>
      <previousSearch
        v-for="previousSearchItem in lastSearchesList"
        v-bind:name="previousSearchItem.name"
        v-bind:city="previousSearchItem.city"
        v-bind:categoryId="previousSearchItem.categoryId"
        v-bind:startTime="previousSearchItem.startTime"
        v-bind:totalEvents="previousSearchItem.totalEvents"
        v-on:previousSearch="search"
        v-bind:key="previousSearchItem.time" />
    </div>
    <div class="row mt mb">
      <div v-if="totalEvents == 0" class="text-center">
        <h2>There are no events that match the search</h2>
      </div>
      <div v-if="totalEvents == -1" class="text-center">
        <h2>Searching...</h2>
      </div>
      <div v-if="totalEvents > 0">
        <h2>Events ({{ totalEvents }} found)</h2>
      </div>
      <event
        v-for="item in eventList"
        v-bind:event="item"
        v-bind:key="item.id"
        v-on:search="search" />
    </div>
    <div class="row mt mb" v-if="totalEvents > eventList.length">
      <div class="col-xs-12 col-sm-4 col-sm-offset-4 mt mb">
        <button type="button" class="btn btn-primary btn-lg btn-block" v-on:click="loadMore()">
          Load more ({{ eventList.length }}/{{ totalEvents }} events in screen)
        </button>
      </div>
    </div>
  </div>
</template>

<script>
  import Event from './event.vue'
  import Search from './search.vue'
  import PreviousSearch from './previous_search.vue'

  export default {
    components: {
      event: Event,
      search: Search,
      previousSearch: PreviousSearch
    },
    data: function () {
      return {
        eventList: [],
        totalEvents: -1,
        page: 1,
        searchName: "",
        searchCategoryId: "",
        searchCity: "",
        searchEmail: "",
        searchStartTime: this.$moment().format('YYYY-MM-DD'),
        lastSearchesList: this.lastSearches()
      }
    },
    mounted: function()
    {
      this.fetchApiEvents(false)
      this.checkNewResultsOnPreviousSearches()
    },
    methods: {
      fetchApiEvents: function(store) {
        this.$http.get('/api/events', {
          params: {
            name: this.searchName,
            categories: [this.searchCategoryId],
            city: this.searchCity,
            start_time: this.searchStartTime,
            email: this.searchEmail,
            page: this.page
          }
        }).then(response => {
          this.eventList = [...this.eventList, ...response.data]
          this.totalEvents = parseInt(response.headers['x-total-count'])
          if(store) this.storeSearch();
        }).catch(error => {
          alert(`Error : ${error}`)
          // TODO: To improve
        });
      },
      loadMore: function() {
        this.page = this.page + 1
        this.fetchApiEvents(false)
      },
      search: function(name, categoryId, city, startTime, email) {
        this.searchName = name
        this.searchCategoryId = categoryId
        this.searchCity = city
        this.searchStartTime = startTime
        this.searchEmail = email
        this.eventList = []
        this.totalEvents = -1
        this.page = 1
        this.fetchApiEvents(true)
      },
      storeSearch: function() {
        var tempLastSearches = this.lastSearches()
        if(tempLastSearches.length > 4) tempLastSearches.splice(0, 1)
        tempLastSearches.push({
          name: this.searchName,
          categoryId: this.searchCategoryId,
          city: this.searchCity,
          startTime: this.searchStartTime,
          totalEvents: this.totalEvents,
          time: Date.now()
        })
        this.lastSearchesList = tempLastSearches
        this.$localStorage.set('lastSearchesLocalStorage', tempLastSearches)
      },
      lastSearches: function() {
        return this.$localStorage.get('lastSearchesLocalStorage', [], Array)
      }
    },
    localStorage: {
      lastSearchesLocalStorage: {
        type: Array
      }
    }
  }
</script>

<style scoped>
</style>
