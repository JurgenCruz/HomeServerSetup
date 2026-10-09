<script setup lang="ts">
defineProps({
  title: {type: String, required: true},
  href: {type: String, required: true}
})
</script>

<template>
  <div class="button">
    <a class="link" :href="href">
      <span class="title">{{ title }}</span>
    </a>
  </div>
</template>

<style scoped lang="scss">
.button {
  box-sizing: border-box;
  margin: 0;
  padding: 5px 0;
  border: 0;
}

.link {
  border: 1px solid var(--vp-c-divider);
  border-radius: 0.5rem;
  padding: 0.6875rem 1rem 0.8125rem;
  width: 100%;
  height: 100%;
  transition: border-color 0.25s;
  margin: 0 0 0 auto;
  text-align: right;
  display: block;
  text-decoration: none;

  &:hover {
    border-color: var(--vp-c-brand-1);
  }
}

.title {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--vp-c-brand-1);
  transition: color 0.25s;
}
</style>