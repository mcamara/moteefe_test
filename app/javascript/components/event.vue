<template>
  <div class="event col-xs-12 col-sm-6 col-lg-4">
    <div class="event-image">
      <img :src="event.image_url">
    </div>
    <div class="event-title">
      <h4>{{ event.name }}</h4>
      <h5>{{ event.city.name }} </h5>
      <h5><small> {{ parseTime(event.start_time) }}</small></h5>
      <button
        class="btn btn-xs btn-link"
        v-for="category in event.categories"
        v-text="category.name"
        v-on:click="searchCategory(category.id)"
        />
    </div>

  </div>
</template>

<script>
  export default {
    props: ['event'],
    methods: {
      searchCategory: function(categoryId) {
        this.$emit('search', "", categoryId, "", "")
      },
      parseTime: function(time) {
        return this.$moment(time).format('dddd, DD MMMM, YYYY, h:mm A')
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
