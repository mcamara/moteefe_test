<template>
  <button class="btn btn-xs btn-link ml mr" v-on:click="previousSearch()">
    {{ text() }}
  </button>
</template>

<script>
  export default {
    props: ['name', 'city', 'categoryId', 'startTime', 'totalEvents'],
    methods: {
      previousSearch: function() {
        debugger
        this.$emit('previousSearch', this.name, this.categoryId, this.city, this.startTime)
      },
      text: function() {
        var text = ` (${this.startTime})`
        if (this.name.length > 0) text = `Text: ${this.name} / ${text}`
        else text = `No text / ${text}`
        if (this.city.length > 0) text = `City: ${this.city} / ${text}`
        if (parseInt(this.categoryId) > 0) text = `Category id: ${this.categoryId} / ${text}`
        return text
      }
    }
  }
</script>

<style scoped>
 div.event {
   padding: 40px;
   height: 350px;
 }
 .event-image {
   height: 180px;
   width: 100%;
   overflow: hidden
 }
 .event-image img {
   height: auto;
   width: 100%;
 }
</style>
